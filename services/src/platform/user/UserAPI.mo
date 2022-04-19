
import Global "../state/Global";

module {

    public type GlobalCache = Global.GlobalCache;
    
    public func countUserTotal(globalCache: ) : Nat {
        globalCache.userCount
    };
    
}