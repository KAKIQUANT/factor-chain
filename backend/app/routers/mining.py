from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from web3 import Web3

router = APIRouter()

# Connect to Conflux or Ethereum network via Web3
w3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'))

# Smart contract details
contract_address = 'YOUR_CONTRACT_ADDRESS'
contract_abi = [
    # Add your contract ABI here
]

# Create contract instance
contract = w3.eth.contract(address=contract_address, abi=contract_abi)

# Pydantic model for mining request
class MineRequest(BaseModel):
    nonce: int
    expression: str
    parentIds: list[int]

@router.post("/mine")
def mine_factor(request: MineRequest):
    try:
        # Verify the mining result by checking the hash
        calculated_hash = Web3.solidityKeccak(
            ['uint256', 'address', 'uint256'],
            [request.nonce, w3.eth.default_account, request.nonce]
        ).hex()

        if int(calculated_hash, 16) % 1 != 0:  # Replace 1 with the actual difficulty level
            raise HTTPException(status_code=400, detail="Invalid mining result")

        # Interact with the smart contract to add the mined factor
        tx_hash = contract.functions.addFactor(request.expression, request.parentIds).transact()
        
        # Return the transaction hash
        return {"transaction_hash": tx_hash.hex()}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/factor/{factor_id}")
def get_factor(factor_id: int):
    try:
        factor = contract.functions.getFactor(factor_id).call()
        return factor
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
