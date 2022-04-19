
import List "mo:base/List";
import Option "mo:base/Option";
import Text "mo:base/Text";
import Trie "mo:base/Trie";

import TagDomain "TagDomain";
import TrieRepositories "../repositories/TrieRepositories";

/// Tag数据存储及访问
module {
    
    public type TagCategory = TagDomain.TagCategory;
    public type TagDB = TrieRepositories.TrieDB<TagCategory, ()>;
    public type TagRepository = TrieRepositories.TrieRepository<TagCategory, ()>;
    public type TagDBKey = TrieRepositories.TrieDBKey<TagCategory>;

    public let tagEq = TagDomain.tagEq;

    /// 辅助方法，Tag的Trie.Key实例
    public func tagDBKey(k: TagCategory): TagDBKey {
        { key = k; hash = Text.hash(k) }
    };

    public func newTagDB() : TagDB {
        Trie.empty<TagCategory, ()>()
    };

    public func newTagRepository() : TagRepository {
        TrieRepositories.TrieRepository<TagCategory, ()>()
    };

    /// 保存tag
    public func saveTag(db: TagDB, repository: TagRepository, category: TagCategory) : TagDB {
        let newDB = repository.update(db, (), tagDBKey(category), tagEq).0;
        newDB
    };

    /// 删除指定的tag
    /// Args:
    ///     |db|    标签类型数据源
    ///     |keyOfTag| 被删除的标签类型主键
    /// Returns:
    ///     删除指定标签类型的标签类型数据源与删除的标签类型数据组成的元组,如果指定的标签类型不存在数据源中存,该值为null
    public func deleteTag(db: TagDB, tagRepository: TagRepository, keyOfTag: TagCategory) : (TagDB, ?()) {
        tagRepository.delete(db, tagDBKey(keyOfTag), tagEq)
    };

    /// 总标签类型数
    public func countTagTotal(db : TagDB) :  Nat {
        Trie.size<TagCategory, ()>(db)
    };

    /// 获取所有标签类型
    public func allTags(db: TagDB) : [TagCategory] {
        Trie.toArray<TagCategory, (), TagCategory>(db, func (tag, _) : TagCategory { tag })
    };

    /// 判断指定标签类型是否存在
    public func isExistedTag(db: TagDB, repository: TagRepository, tag: TagCategory) : Bool {
        Trie.some<TagCategory, ()>(db, func (t, _) : Bool { t == tag })
    };
}