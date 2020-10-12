pragma solidity >=0.4.0 <=0.6.0;

contract Ecommerce
{
    
    struct Product
    {
        uint256 id;
        string Name;
        uint256 inventory; //Quantity
        uint256 price;
    }
    
    struct User
    {
        string name;
        string email;
        string _address;
        uint order_tol;
        bool is_active;
    }
    
    struct Order
    {
        uint Orderid;
        uint Productid;
        uint Quantity;
        address buyer;
    }
    
    mapping(uint => Product) public product;
    mapping(address => User) public user;
    mapping(uint => Order) public order;

    event NewProduct(uint _ID,string Name,uint _Inventory,uint price);
    event NewBuyer(string Name,string email,string _address);
    event NewOrder(uint _ProductID,uint _Quantity,uint order_Amount);
    
    address public Owner;
    uint public newProduct;
    uint public newBuyer;
    uint public newOrder;
    
    modifier onlyOwner()
    {
        if(msg.sender != Owner)
            revert("Only User is allowed");
            _;
    }
    
    function ProductSales() public
    {
        Owner = msg.sender;
        newProduct = 0;
        newBuyer = 0;
    }
    
    function RegisterUser(string memory Name,string memory email,string memory _address) public
    {
        User storage p = user[msg.sender];
        p.name = Name;
        p.email = email;
        p._address = _address;
        p.order_tol = 0;
        p.is_active = true;
        newBuyer++;
        emit NewBuyer(Name,email,_address);
    
    }
    
    function UpdateUser(string memory Name,string memory email,string memory _address) public
    {
        user[msg.sender].name = Name;
        user[msg.sender].email = email;
        user[msg.sender]._address = _address;
    }
    
    
    function AddProduct(uint _ID,string memory Name,uint _Inventory,uint price) public onlyOwner
    {
        Product storage p = product[_ID];
        p.id = _ID;
        p.Name = Name;
        p.inventory = _Inventory;
        p.price = price;
        newProduct++;
        emit NewProduct(_ID,Name,_Inventory,price);
    
    }
    

    
    function UpdateProduct(uint _ID,string memory Name,uint _Inventory,uint price) public onlyOwner
    {
        product[_ID].Name = Name;
        product[_ID].inventory = _Inventory;
        product[_ID].price = price;
    }
    
    
    function BuyProduct(uint _ProductID,uint _Quantity,uint order_Amount) public returns(uint newOrderID)
    {
        
        if (product[_ProductID].inventory < _Quantity)
        {
            revert("Product Doesn't have Quantity");
        }
        
        uint order_total = product[_ProductID].price * _Quantity;
        
        if(order_total < order_Amount)
        {
            revert("Pay Proper Values");
        }
        
        if(user[msg.sender].is_active != true)
        {
            revert("Invalid User!!!!");
        }
        
        user[msg.sender].order_tol +=1;
        
        newOrderID = uint(msg.sender) + block.timestamp;
        
        // Create Order
        Order storage o = order[newOrderID];
        o.Orderid  = newOrderID;
        o.Productid= _ProductID;
        o.Quantity = _Quantity;
        o.buyer    = msg.sender;
        
        newOrder++;
        
        // Update Qunatity
        
        product[_ProductID].inventory = product[_ProductID].inventory -  _Quantity;
        
        // Refund Values to buyer
        
        // if(msg.value > order_Amount)
        // {
        //     uint refund_amount = msg.value - order_Amount;
            
        //     if(!msg.sender.send(refund_amount))
        //     revert('User nahi hai ');
        // }
        
        emit NewOrder(_ProductID,_Quantity,order_Amount);
        
    }
    
    // function withdrawfunds() public onlyOwner{
    //     if(!Owner.send(this.balance))
    //     revert("Only onlyOwner");
    // }
    
    // function killOwner() public onlyOwner
    // {
    //     suicide(Owner);
    // }
    
    
}

