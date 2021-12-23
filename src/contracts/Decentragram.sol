pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  //store image
  uint public imageCount = 0;
  mapping(uint => Image)public images;

  struct Image{
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tip,
    address payable author
  );
  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tip,
    address payable author
  );



  //create image
  function uploadImage(string memory _imgHash,string memory _description)public {
    //condition for imgHash, décription and msg.sender
    require(bytes(_imgHash).length>0);
    require(bytes(_description).length>0);
    require(msg.sender != address(0x0));


    //increment image id
    imageCount++;

    //add image to contract
    images[imageCount] = Image(imageCount,_imgHash,_description,0,msg.sender);

    //trigger the event
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  //tip image
  function tipImageOwner(uint _id)public payable{
    require(_id > 0 && _id <= imageCount);

    //fetch image
    Image memory _image = images[_id];

    //fetch the author
    address payable _author = _image.author;
    //pay author by send them ether
    address(_author).transfer(msg.value);

    _image.tipAmount += msg.value;
    images[_id] = _image;

    emit ImageTipped(_id, _image.hash,_image.description, _image.tipAmount, _author);
  }
}