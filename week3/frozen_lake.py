import numpy as np
import random
import matplotlib.pyplot as plt

# Set board parameters
BOARD_ROWS = 5
BOARD_COLS = 5

START = (0, 0)
WIN_STATE = (4, 4)
HOLE_STATE = {(1, 0), (3, 1), (4, 2), (1, 3)}  # Using set for faster lookup

ACTIONS = [0, 1, 2, 3]  # up, down, left, right

class State:
    def __init__(self, state=START):
        self.state = state
        self.isEnd = self._check_end()

    def _check_end(self):
        return self.state == WIN_STATE or self.state in HOLE_STATE

    def getReward(self):
        if self.state == WIN_STATE:
            return 1
        elif self.state in HOLE_STATE:
            return -5
        return -1

    def next_position(self, action):
        i, j = self.state
        if action == 0:  # up
            i -= 1
        elif action == 1:  # down
            i += 1
        elif action == 2:  # left
            j -= 1
        elif action == 3:  # right
            j += 1
        if 0 <= i < BOARD_ROWS and 0 <= j < BOARD_COLS:
            return (i, j)
        return self.state


class Agent:
    def __init__(self):
        self.state = State()
        self.Q = {(i, j, a): 0.0 for i in range(BOARD_ROWS)
                                  for j in range(BOARD_COLS)
                                  for a in ACTIONS}
        self.alpha = 0.5
        self.gamma = 0.9
        self.epsilon = 0.1
        self.plot_reward = []

    def choose_action(self, state):
        if random.random() > self.epsilon:
            # Exploitation: choose best action
            values = [self.Q[(state[0], state[1], a)] for a in ACTIONS]
            max_value = max(values)
            best_actions = [a for a, v in zip(ACTIONS, values) if v == max_value]
            return random.choice(best_actions)
        else:
            # Exploration
            return random.choice(ACTIONS)

    def Q_Learning(self, episodes):
        for ep in range(episodes):
            self.state = State()
            total_reward = 0

            while not self.state.isEnd:
                curr_pos = self.state.state
                action = self.choose_action(curr_pos)
                next_pos = self.state.next_position(action)
                reward = self.state.getReward()
                total_reward += reward

                max_future_q = max(self.Q[(next_pos[0], next_pos[1], a)] for a in ACTIONS)
                current_q = self.Q[(curr_pos[0], curr_pos[1], action)]

                # Q-value update
                self.Q[(curr_pos[0], curr_pos[1], action)] = round(
                    (1 - self.alpha) * current_q + self.alpha * (reward + self.gamma * max_future_q), 3
                )

                self.state = State(state=next_pos)

            self.plot_reward.append(total_reward)

    def plot(self):
        plt.plot(self.plot_reward)
        plt.title("Cumulative Rewards over Episodes")
        plt.xlabel("Episode")
        plt.ylabel("Total Reward")
        plt.grid(True)
        plt.savefig("reward_plot.png")

    def showValues(self):
        print("Learned Q-values (max per state):")
        for i in range(BOARD_ROWS):
            print("-" * 60)
            out = "| "
            for j in range(BOARD_COLS):
                max_q = max(self.Q[(i, j, a)] for a in ACTIONS)
                out += f"{max_q:<6.2f} | "
            print(out)
        print("-" * 60)


if __name__ == "__main__":
    agent = Agent()
    episodes = 10000
    agent.Q_Learning(episodes)
    agent.plot()
    agent.showValues()

