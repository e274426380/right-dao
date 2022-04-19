
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";

import Domain "./Domain";
// import Utils "./Domain";


module {
    public type PictureId = Domain.PictureId;
    public type Picture = Domain.Picture;
    public type PictureProfile = Domain.PictureProfile;
    public type StablePictureMap = Domain.StablePictureMap;

    public type UserPrincipal = Domain.UserPrincipal;

    public type PictureDB = Trie.Trie<PictureId, PictureProfile>;
    
    public class PictureRepository() {
        
        public func getPictureProfile(pics: StablePictureMap, picId: PictureId) : ?PictureProfile {
            Trie.find<PictureId, PictureProfile>(pics, Domain.keyOfPicture(picId), Nat.equal)     
        };

        public func getPicture(pics: StablePictureMap, picId: PictureId) : ?Picture {
            Option.map<PictureProfile, Picture>(
                getPictureProfile(pics, picId), 
                func (picInfo) : Picture { picInfo.pic }
            )   
        };

        public func getPics(pics: StablePictureMap, picIds: [PictureId]) : [(PictureId, Picture)] {
            let containPics = Trie.mapFilter<PictureId, PictureProfile, Picture>(pics, func (pid, picInfo) : ?Picture {
                // Array.find<PictureId>(picIds, func (id) { id == pid })
                switch (Array.find<PictureId>(picIds, func (id) : Bool { pid == id })) {
                    case (?_) ?picInfo.pic;
                    case _  null;
                }
            });

            Trie.toArray<PictureId, Picture, (PictureId, Picture)>(containPics, func (pid, pic) : (PictureId, Picture) {
                (pid, pic)
            })    
        };

        public func findPicsByOwner(pics: StablePictureMap, owner: UserPrincipal): StablePictureMap {
            let picsByOwner = Trie.filter<PictureId, PictureProfile>(pics, func (k, v) {
                v.owner == owner
            });
            picsByOwner
        };

        public func countPicsByOwner(pics: StablePictureMap, owner: UserPrincipal): Nat {       
            Trie.size<PictureId, PictureProfile>(findPicsByOwner(pics, owner))
        };

        public func updatePic(pics: StablePictureMap, picInfo: PictureProfile) : (StablePictureMap, ?PictureProfile) {
            Trie.put<PictureId, PictureProfile>(pics, Domain.keyOfPicture(picInfo.id), Nat.equal, picInfo);
        };

        public func deletePic(pics: StablePictureMap, picId: PictureId) : (StablePictureMap, ?PictureProfile) {
            let res = Trie.remove<PictureId, PictureProfile>(pics, Domain.keyOfPicture(picId), Nat.equal);
            res
        };
    };
    
};