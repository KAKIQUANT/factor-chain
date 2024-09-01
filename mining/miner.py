import numpy as np
import gplearn.genetic as gp
import requests

# Constants
NODE_URL = "http://localhost:8000"

# Define a custom fitness function
def fitness_function(X, y, sample_weight):
    # Example fitness function: minimize mean squared error
    return -np.mean(np.square(y - X))

# Set up the genetic programming regressor
est_gp = gp.SymbolicRegressor(
    population_size=5000,
    generations=20,
    tournament_size=20,
    stopping_criteria=0.01,
    const_range=(-1.0, 1.0),
    init_depth=(2, 6),
    init_method='half and half',
    function_set=('add', 'sub', 'mul', 'div'),
    metric=fitness_function,
    parsimony_coefficient=0.01,
    p_crossover=0.7,
    p_subtree_mutation=0.1,
    p_hoist_mutation=0.05,
    p_point_mutation=0.1,
    p_point_replace=0.05,
    max_samples=1.0,
    verbose=1,
    random_state=0,
    n_jobs=1
)

# Define a function to mine factors using GPlearn
def mine_factor(data, target):
    est_gp.fit(data, target)
    best_program = est_gp._program

    return best_program

def submit_mined_factor(expression, parent_ids):
    response = requests.post(f"{NODE_URL}/mine", json={
        "expression": expression,
        "parentIds": parent_ids
    })
    return response.json()

# Example usage
data = np.random.rand(100, 10)  # Example data
target = np.random.rand(100)    # Example target

best_expression = mine_factor(data, target)
parent_ids = [1, 2]
result = submit_mined_factor(str(best_expression), parent_ids)
print(result)
