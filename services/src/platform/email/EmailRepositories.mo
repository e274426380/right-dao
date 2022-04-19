//! src/dapp/emails/EmailRepositories.mo

import List "mo:base/List";
import Order "mo:base/Order";

import EmailDomain "./EmailDomain";
import ListRepository "../repositories/ListRepository";
import PageHelper "../base/PageHelper";

module {

    public type EmailAddress = EmailDomain.EmailAddress;
    public type EmailSubscription = EmailDomain.EmailSubscription;

    public type EmailPage = PageHelper.Page<EmailSubscription>;

    public type EmailAddressDB = ListRepository.ListDB<EmailSubscription>;

    public type EmailAddressRepository = ListRepository.ListRepository<EmailSubscription>;

    public func newEmailAddressDB() : EmailAddressDB {
        List.nil()
    };

    public func newEmailAddressRepository() : EmailAddressRepository {
        ListRepository.ListRepository<EmailSubscription>()
    };

    public func findOneEmailAddress(db: EmailAddressDB, repository: EmailAddressRepository, filterEmail: EmailAddress) : ?EmailSubscription {
        repository.findOne(db, func (e) : Bool { e.email == filterEmail })
    };
    
    public func getNewerEmailAddress(db: EmailAddressDB, repository: EmailAddressRepository, n: Nat) : [EmailSubscription] {
        List.toArray<EmailSubscription>(repository.getNewer(db, n))
    };

    public func pageEmail(db: EmailAddressDB, repository: EmailAddressRepository, pageSize: Nat, pageNum: Nat,
        filter: EmailSubscription -> Bool, sortWith: (EmailSubscription, EmailSubscription) -> Order.Order) : EmailPage {
        repository.page(db, pageSize, pageNum, filter, sortWith)
    };

    public func saveEmailAddress(db: EmailAddressDB, repository: EmailAddressRepository, es: EmailSubscription) : EmailAddressDB {
        repository.save(db, es)
    };

    public func deleteEmailAddress(db: EmailAddressDB, repository: EmailAddressRepository, emailAddress: EmailAddress) : EmailAddressDB {
        repository.delete(db, func (e) : Bool { e.email != emailAddress})
    };

    public func allEmails(db: EmailAddressDB) : [EmailSubscription] {
        List.toArray<EmailSubscription>(db)
    };
}