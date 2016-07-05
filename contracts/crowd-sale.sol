contract Token {
    
    string public name = "Project Dao Token 0.5.0";
    string public symbol = "PDT";
    uint8 public decimals = 0;
    address public owner;
    address public beneficiaryAddress;
    uint256 public cost = 10000000000000000;      // .01ETH: 100PDT=1ETH
    uint256 public totalTokens = 0;

    mapping (address => uint256) public balanceOf;
    
    function Token() {
        owner = msg.sender;
        beneficiaryAddress = msg.sender;
    }

    event SetBeneficiaryAddress (address newBeneficiary);
    event Transfer( address indexed from, address indexed to, uint256 value );
    event BuyToken(address buyerAddress, uint256 ethAmount, uint256 tokenAmount);
    event WithdrawEth(address beneficiaryAddress, uint256 withdrawlAmount);

    function setBeneficiaryAddress(address _newBeneficiary) {
        beneficiaryAddress = _newBeneficiary;
        SetBeneficiaryAddress(_newBeneficiary);
    }

    function transferTokens(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function buyTokens() returns (uint amount) {
        amount = msg.value / cost;
        balanceOf[msg.sender] += amount;
        totalTokens += amount;
        BuyToken(msg.sender, msg.value, amount);
        return amount;
    }

    function withdrawEth(uint256 _value) {
        if (msg.sender != beneficiaryAddress) throw;
        WithdrawEth(msg.sender, _value);
        beneficiaryAddress.send(_value);
    }
}