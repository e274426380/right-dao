
import List "mo:base/List";
import Order "mo:base/Order";

import PageHelper "../base/PageHelper";
import Utils "../base/Utils";

module {

    public type Page<T> = PageHelper.Page<T>;

    public type ListDB<T> = List.List<T>;

    public class ListRepository<T>() {
        public func findOne(db: ListDB<T>, filter: (T) -> Bool) : ?T {
            List.find<T>(db, filter)
        };

        public func findBy(db: ListDB<T>, filter: T -> Bool) : ListDB<T> {
            List.filter(db, filter)
        };

        public func save(db: ListDB<T>, entity: T): ListDB<T> {
            List.push<T>(entity, db)
        };

        public func delete(db: ListDB<T>, filter: (T) -> Bool) : ListDB<T> {
            List.filter<T>(db, filter)
        };

        public func getNewer(db: ListDB<T>, n: Nat) : ListDB<T> {
            List.take<T>(db, n)
        };

        public func page(db: ListDB<T>, pageSize: Nat, pageNum: Nat, filter: T -> Bool, 
            sortWith: (T, T) -> Order.Order) : Page<T> {
            
            let filtered = findBy(db, filter);
            let skipCounter = pageNum * pageSize;
            let sortedData = List.fromArray<T>(Utils.sort(List.toArray<T>(filtered), sortWith));

            let remainning = List.drop<T>(sortedData, skipCounter);
            let paging = List.take<T>(remainning, pageSize);
            let totalCount = List.size<T>(sortedData);

            {
                data = List.toArray<T>(paging);
                pageSize = pageSize;
                pageNum = pageNum;
                totalCount = totalCount;
            }
        };

    }
}