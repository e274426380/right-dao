
module {
    public type Page<T> = {
        data : [T];
        pageSize : Nat;
        pageNum : Nat;
        totalCount: Nat;
    };
}