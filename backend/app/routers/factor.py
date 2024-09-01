from fastapi import APIRouter, HTTPException
from web3 import Web3

router = APIRouter()

w3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'))
contract_address = 'YOUR_CONTRACT_ADDRESS'
contract_abi = [
    # Add your contract ABI here
]

contract = w3.eth.contract(address=contract_address, abi=contract_abi)

@router.get("/factor/{factor_id}")
def get_factor(factor_id: int):
    try:
        factor = contract.functions.getFactor(factor_id).call()
        return factor
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
