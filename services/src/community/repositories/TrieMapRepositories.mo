//! src/repositories/TrieMapRepository.mo

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import TrieMap "mo:base/TrieMap";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Order "mo:base/Order";

import PageHelper "../base/PageHelper";
import Utils "../base/Utils";

/// DFINITY使用WebAssembly运行时,其中的runtime memory在升级或重启会丢失,
/// 需要在系统重启前执行的系统方法preupgrade()中把cache中内容store到stable memory,
/// 在系统重启后执行系统方法postupgrade()把stable memory中的数据加载到runtime memory
/// 使用TrieMap作为WebAssembly保存runtime memory数据的数据容器
module {

    public type DB<K, V> = [(K, V)];

    public type ValueDB<V> = [V];

    public type TrieMapCache<K, V> = TrieMap.TrieMap<K, V>;

    public type Set<K> = TrieMapCache<K, ()>;

    public type Page<X> = PageHelper.Page<X>;

    public class TrieMapRepository<K, V>() {
        /// 根据id查询，如果对应的id存在，返回?V，否则返回null
        public func get(cache: TrieMapCache<K, V>, k: K) : ?V {
            cache.get(k)
        };

        /// 根据过滤条件查询，返回符合条件的数据集
        public func findBy<R>(cache: TrieMapCache<K, V>, 
            keyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash, mapFn : (K, V) -> ?R): TrieMapCache<K, R> {
            TrieMap.mapFilter<K, V, R>(cache, keyEq, keyHash, mapFn)
        };

        /// 根据过滤条件统计数量，返回满足条件的记录数，否则返回0
        public func countSize(cache: TrieMapCache<K, V>) : Nat {       
            cache.size()
        };

        /// 通过指定的Key和value，更新数据集，返回被更新key的旧value,或者null
        public func update(cache: TrieMapCache<K, V>, k: K, v: V) : ?V {
            cache.replace(k, v)
        };

        /// 从数据集中删除指定的记录，返回删除指定记录的数据集和被删除的记录（如果id对应的记录存在，否则返回null）
        public func delete(cache: TrieMapCache<K, V>, k: K) : ?V {
            cache.remove(k)
        };

        /// 缓存数据过滤并排序,返回分页
        public func page(cache: TrieMapCache<K, V>, pageSize: Nat, pageNum: Nat,  
            filter: (K, V) -> Bool, sortWith: (V, V) -> Order.Order) : Page<V> {
            
            let filteredBuffer = Buffer.Buffer<V>(cache.size());

            for ((k, v) in cache.entries()) {
                if (filter(k, v)) {
                    filteredBuffer.add(v);
                };
            };
            // let filtered = TrieMap.mapFilter<K, V, V>(cache, func (k, v) : ?V {
            //     if (filter(k, v)) {?v} else null
            // });
            
            let dataArray = filteredBuffer.toArray();           

            let sortedData = List.fromArray<V>(Utils.sort(dataArray, sortWith));

            let skipCounter = pageNum * pageSize;
            let remainning = List.drop<V>(sortedData, skipCounter);
            let paging = List.take<V>(remainning, pageSize);
            let totalCount = List.size<V>(sortedData);

            {
                data = List.toArray<V>(paging);
                pageSize = pageSize;
                pageNum = pageNum;
                totalCount = totalCount;
            }
        };

    };

    public func cacheToDB<K, V>(cache: TrieMapCache<K, V>) : [(K, V)] {
        Iter.toArray(cache.entries())
    };

    public func dbToCache<K, V>(arr: [(K, V)], keyEq: (K, K) -> Bool, keyHash: K -> Hash.Hash) : TrieMapCache<K, V> {  
        var cache = newTrieMapCache<K, V>(keyEq, keyHash);
        for ((k, v) in arr.vals()) {
            cache.put(k, v);
        };
        cache
    };

    public func newDB<K, V>() : DB<K, V> {
        []
    };
    
    public func newTrieMapCache<K, V>(keyEq: (K, K) -> Bool, keyHash: K -> Hash.Hash) : TrieMapCache<K, V> {
        TrieMap.TrieMap<K, V>(keyEq, keyHash)
    };

    public func newSet<K>(keyEq: (K, K) -> Bool, keyHash: K -> Hash.Hash) : Set<K> {
        newTrieMapCache<K,()>(keyEq, keyHash)
    };

    public func getEntityByIds<K, V>(cache: TrieMapCache<K, V>, repository: TrieMapRepository<K, V>, ids: Set<K>) : [V] {
        let size = ids.size();
        var tempBuffer = Buffer.Buffer<V>(size);

        for ((id, _) in ids.entries()) {
            switch (repository.get(cache, id)) {
                case (?e) { tempBuffer.add(e); };
                case (null) { }
            }
        };

        tempBuffer.toArray()     
    };

    public func nestedMapToArray<K1, K2, V>(cache: TrieMapCache<K1, TrieMapCache<K2, V>>) : [(K1, [(K2, V)])] {
        let outerSize = cache.size();
        var outerBuffer = Buffer.Buffer<(K1, [(K2, V)])>(outerSize);

        for ((k1, v1) in cache.entries()) {
            let innerSize = v1.size();
            var innerBuffer = Buffer.Buffer<(K2, V)>(innerSize);
            for ((k2, v) in v1.entries()) {
                innerBuffer.add((k2, v));
            };
            outerBuffer.add(k1, innerBuffer.toArray())
        };

        outerBuffer.toArray()
    };

    public func nestedArrayToMap<K1, K2, V>(arr: [(K1, [(K2, V)])], key1Eq: (K1, K1) -> Bool, key1Hash: K1 -> Hash.Hash,
        key2Eq: (K2, K2) -> Bool, key2Hash: K2 -> Hash.Hash) : TrieMapCache<K1, TrieMapCache<K2,V>> {
        let outIter = Array.vals<(K1, [(K2, V)])>(arr);
        let outCache = newTrieMapCache<K1, TrieMapCache<K2, V>>(key1Eq, key1Hash);

        for ((k1, k2v) in outIter) {
            outCache.put(
                k1, 
                dbToCache<K2, V>(k2v, key2Eq, key2Hash)
            );
        };

        outCache
        
    };

    public func valueDBToCache<K, V>(db: ValueDB<K>, f: K -> V, keyEq: (K, K) -> Bool, keyHash: K -> Hash.Hash) : TrieMapCache<K, V> {
        var cache = newTrieMapCache<K, V>(keyEq, keyHash);
        for (k in db.vals()) {
            cache.put(k, f(k));
        };
        cache
    };

    public func valueDBToSet<X, Y>(db: ValueDB<X>, f: X -> Y, keyEq: (Y, Y) -> Bool, keyHash: Y -> Hash.Hash) : Set<Y> {
        var cache = newTrieMapCache<Y, ()>(keyEq, keyHash);
        for (x in db.vals()) {
            cache.put(f(x), ());
        };
        cache
    };

    public func cacheToKeyDB<K, V>(cache: TrieMapCache<K, V>) : ValueDB<K> {
        let outerSize = cache.size();
        var buffer = Buffer.Buffer<K>(outerSize);
        for ((k, _) in cache.entries()) {
            buffer.add(k);
        };

        buffer.toArray()
    };

    public func hashSetCacheToDB<K1, K2>(cache: TrieMapCache<K1, Set<K2>>) : DB<K1, ValueDB<K2>> {
        let outerSize = cache.size();
        var outerBuffer = Buffer.Buffer<(K1, [K2])>(outerSize);
        for ((k1, k2s) in cache.entries()) {
            let innerSize = k2s.size();
            var innerBuffer = Buffer.Buffer<K2>(innerSize);
            for ((k2, _) in k2s.entries()) {
                innerBuffer.add(k2);
            };

            outerBuffer.add((k1, innerBuffer.toArray()));
        };

        outerBuffer.toArray()
    };

    public func dbToSetCache<K1, K2>(db: DB<K1, ValueDB<K2>>, key1Eq: (K1, K1) -> Bool, key1Hash: K1 -> Hash.Hash, key2Eq: (K2, K2) -> Bool, key2Hash: K2 -> Hash.Hash): TrieMapCache<K1, Set<K2>> {
        var cache = newTrieMapCache<K1, Set<K2>>(key1Eq, key1Hash);
        for ((k1, k2s) in db.vals()) {
            var k2Set = newSet<K2>(key2Eq, key2Hash);
            for (k2 in k2s.vals()) {
                k2Set.put(k2, ());
            };

            cache.put(k1, k2Set);
        };

        cache
    };
};