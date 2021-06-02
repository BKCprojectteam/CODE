interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
contract BKC {
string public name;
string public symbol; uint8 public decimals = 18;
uint256 public totalSupply;
mapping (address => uint256) public balanceOf;
mapping (address => mapping (address => uint256)) public allowance;
event Transfer(address indexed from, address indexed to, uint256 value); event Burn(address indexed from, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);
constructor (uint256 initialSupply, string tokenName, string tokenSymbol) public {
totalSupply = initialSupply * 10 ** uint256(decimals); supply with the decimal amount
balanceOf[msg.sender] = totalSupply;
all initial tokens
// Update total
// Give the creator // Set the name for // Set the symbol for
display display
}
/** *
*/
name = tokenName;
purposes
symbol = tokenSymbol;
purposes
@dev total number of tokens issued
function totalSupply() public view returns (uint256) { return totalSupply;
}
/**
* @dev Gets the balance of the specified address.
* @param _owner The address to query the the balance of.
* @return An uint256 representing the amount owned by the
*/
function _balanceOf(address _owner) public view returns (uint256 balance) { return balanceOf[_owner];
}
function _transfer(address _from, address _to, uint _value) internal { //SlowMist// This kind of check is very good, avoiding user mistake leading
to the loss of token during transfer
require(_to != 0x0);
require(balanceOf[_from] >= _value); require(balanceOf[_to] + _value > balanceOf[_to]);
uint previousBalances = balanceOf[_from] + balanceOf[_to]; balanceOf[_from] -= _value;
balanceOf[_to] += _value;
emit Transfer(_from, _to,
assert(balanceOf[_from] +
}
/**
* @dev transfer token for a
specified address
* @param _to The address to transfer to.
* @param _value The amount to be transferred. */
function transfer(address _to, uint256 _value) public { _transfer(msg.sender, _to, _value);
}
/**
* @dev Transfer tokens from one address to another
* @param _from address The address which you want to send tokens from * @param _to address The address which you want to transfer to
* @param _value uint256 the amount of tokens to be transferred
*/
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
require(_value <= allowance[_from][msg.sender]); // Check allowance allowance[_from][msg.sender] -= _value;
_transfer(_from, _to, _value);
//SlowMist// The return value conforms to the EIP20 specification return true;
}
/**
* @dev Approve the passed address to spend the specified amount of tokens on
behalf of msg.sender.
* @param _spender The address which will spend the funds. * @param _value The amount of tokens to be spent.
*/
function approve(address _spender, uint256 _value) public
returns (bool success) {
allowance[msg.sender][_spender] = _value;
emit Approval(msg.sender, _spender, _value);
//SlowMist// The return value conforms to the EIP20 specification return true;
}
function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
returns (bool success) {
tokenRecipient spender = tokenRecipient(_spender); if (approve(_spender, _value)) {
spender.receiveApproval(msg.sender, _value, this, _extraData);
return true; }
}
/**
* @dev Function to check the amount of tokens that an owner allowed to a
spender.
* @param _owner address The address which owns the funds.
* @param _spender address The address which will spend the funds.
* @return A uint256 specifying the amount of tokens still available for the
spender. */
function _allowance(address _owner, address _spender) public view returns (uint256) {
return allowance[_owner][_spender]; }
function burn(uint256 _value) public returns (bool success) {
require(balanceOf[msg.sender] >= _value); balanceOf[msg.sender] -= _value; totalSupply -= _value;
emit Burn(msg.sender, _value);
return true; }
// Check if the sender has enough // Subtract from the sender
// Updates totalSupply
//SlowMist// Because burnFrom() and transferFrom() share the allowed amount of approve(), if the agent be evil, there is the possibility of malicious burn
function burnFrom(address _from, uint256 _value) public returns (bool success) {
require(balanceOf[_from] >= _value); balance is enough
require(_value <= allowance[_from][msg.sender]);
balanceOf[_from] -= _value;
targeted balance
allowance[_from][msg.sender] -= _value;
sender's allowance
// Check if the targeted
// Check allowance // Subtract from the
// Subtract from the // Update totalSupply
} }
