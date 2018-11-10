# Requirements

Please implement a game of tic-tac-toe in Ruby 2.3.0 or higher. Your game should be played on a 4x4 board. However, please structure your code so that it's easy to change the size of your board (by changing a few lines of source code).

Your game needs to provide a computer player, who will always go first. This computer player must implement at least 2 different strategies (for example, random walk and minimax) and play reasonably well against its human opponent. At the beginning of the game, please prompt human player to select one of the implemented strategies. The player who first succeeds in placing three consecutive marks in a horizontal, vertical, or diagonal row wins the game.

We expect your game to be executed in the terminal (command line interface). The simplest representation of the game board and communication to prompt human player for moves should be sufficient.

A very important quality for professional software engineer is the ability to write concise and expressive code. Please structure your code to model the problem domain in a way that's easy to understand. Your submission will be judged on its structure, clarity, correctness.

Please also include appropriate tests for your code (see below for more details).

# Guideline

* Feel free to make assumptions about anything that's not stated above - but please state your assumptions in a project read-me.
* Design carefully but please refrain from over-engineering. A simple solution is often a good solution.
* You can use any algorithm and/or heuristic functions for your computer player.

# Testing

For testing, we recommend using rspec. An initial setup has already been included in the project though you are not required to use this setup. To use the provided setup:

1. `gem install bundler` installs bundler.
2. `bundle install` installs rspec and other dependencies.
3. `bundle exec rspec` run all tests in the `spec/` directory.

All of your tests should be added under the `spec/` directory. There are lots of online resources for writing tests in rspec. Feel free to look at any of them. [This](https://blog.teamtreehouse.com/an-introduction-to-rspec) seems like a decent one to start with.

# Submission

Please fork this repository, checkout your own branch, then open a PR against the master branch of this repository. If you have any question, please feel free to email me at zino@chowbus.com.
