import Web3 from 'web3';
import FactorChain from './FactorChain.json';

let web3;
let contract;

if (typeof window !== 'undefined' && typeof window.ethereum !== 'undefined') {
  web3 = new Web3(window.ethereum);
  window.ethereum.request({ method: 'eth_requestAccounts' });

  const contractAddress = 'YOUR_CONTRACT_ADDRESS';
  contract = new web3.eth.Contract(FactorChain.abi, contractAddress);
} else {
  const provider = new Web3.providers.HttpProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID');
  web3 = new Web3(provider);

  const contractAddress = 'YOUR_CONTRACT_ADDRESS';
  contract = new web3.eth.Contract(FactorChain.abi, contractAddress);
}

export { web3, contract };
