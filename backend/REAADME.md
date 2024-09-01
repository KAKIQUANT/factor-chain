# Factor Chain Backend

This is the backend service for the Factor Chain project, built with FastAPI. It handles API requests, interacts with the Conflux blockchain via Web3, and manages the mining and factor submission logic.

## Features

- **API**: Exposes endpoints for interacting with the Factor Chain smart contract.
- **Mining**: Allows users to submit mined factors.
- **Blockchain Interaction**: Interacts with the Conflux blockchain to store and retrieve factors.

## Prerequisites

- Python 3.9+
- [Pip](https://pip.pypa.io/en/stable/installation/)
- [Docker](https://docs.docker.com/get-docker/)

## Local Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/factor-chain.git
cd factor-chain/backend
