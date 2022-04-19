
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Order "mo:base/Order";
import Text "mo:base/Text";

import Utils "../base/Utils";

module {

    /// 邮箱地址
    public type EmailAddress = Text;

    public type Timestamp = Int;

    /// 邮件订阅
    public type EmailSubscription = {
        email: EmailAddress;
        ipAddress: Text;
        status: Text;   // Subscribed(已订阅), Unsubscribed(取消订阅)
        createdAt: Timestamp;
    };

    /// 订阅邮箱命令
    public type EmailSubscribeCommand = {
        email: EmailAddress;
        ipAddress: Text;
    };

    /// 邮箱分页查询请求
    public type EmailPageQuery = {
        email: Text;
        startTime: Timestamp;
        endTime: Timestamp;
        status: Text;
        pageSize: Nat;
        pageNum: Nat;
    };

    public let emailAddressEq = Text.equal;

    public func newEmailSubscription(email: EmailAddress, ipAddress: Text, createdAt: Timestamp) : EmailSubscription {
        {
            email = email;
            ipAddress = ipAddress;
            status = "subscribed";
            createdAt = createdAt;
        }
    };

    public func containsEmail(es: EmailSubscription, email: Text) : Bool {
        Utils.containsStr(Utils.toLowerCase(es.email), Utils.toLowerCase(email))
    };

    public func containsStatus(es: EmailSubscription, status: Text) : Bool {
        Utils.containsStr(es.status, Utils.toLowerCase(status))
    };

    public func emailBetweenCreatedTime(es: EmailSubscription, startTime: Timestamp, endTime: Timestamp) : Bool {
        es.createdAt >= startTime and es.createdAt <= endTime
    };

    public func emailOrderByCreatedAtDesc(es1: EmailSubscription, es2: EmailSubscription) : Order.Order {
        Int.compare(es2.createdAt, es1.createdAt)
    };

    /// valid the email address
    /// 1. 不能包含空格，是否以字母结束 
    /// 2. 字符串长度大于等于5，其中用户名不能超过20个字符，域名也不能超过20个字符
    /// 3. 必须有且只有一个@（电子邮件地址标志符号）
    /// 4. 用户名（@前面的字符串）是字符或数字，或_(下划线)
    /// 5. 域名只能是(@后面的字符串)是是字符或数字，或_(下划线)
    public func validEmailAddress(lowerEmail: EmailAddress): Bool {

        if (Utils.containsSpace(lowerEmail) or not(Utils.endsWithAlpha(lowerEmail))) {
            return false;
        };

        if (Text.size(lowerEmail) < 5) {
            return false;
        };

        if (Utils.onlyOneAt(lowerEmail)) {
            return false;
        };

        let nameAndDomain = Text.split(lowerEmail, #text "@");

        let name = switch (nameAndDomain.next()) {
            case (?t) { t };
            case _ { "" };
        };

        let domain = switch (nameAndDomain.next()) {
            case (?t) { t };
            case _ { "" };
        };

        if (name.size() < 3 or name.size() > 20) {
            return false;
        };

        if (not(validAddressUserName(name))) {
            return false;
        };

        if (not(validAddressDomain(domain))) {
            return false;
        };

        true
    };

    
    /// 校验邮箱地址中用户名是否符合条件
    public func validAddressUserName(text: Text): Bool {
        let str : [Char] = Iter.toArray(Text.toIter(text));
        if (not(Utils.lessOrEqTwentyChar(text))) {
            return false;
        };

        for (i in Iter.range(0, text.size() - 1)) {
            let c = str[i];
            if (not(Utils.isAlpharNumberUnderLine(c))) {
                return false;
            };
        };

        true
    };

    /// 校验邮箱地址中域名是否合条件
    public func validAddressDomain(domain: Text): Bool {
        if (not(Utils.lessOrEqTwentyChar(domain))) {
            return false;
        };

        let splited = Text.split(domain, #text ".");

        for (t in splited) {
            if (Text.size(t) < 1) {
                return false;
            };
        };

        true
        
    };

};
