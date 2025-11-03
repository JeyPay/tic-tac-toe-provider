import 'package:rxdart/rxdart.dart';
import 'package:tic_tac_toe/widgets/game_tick.dart';

///
/// Indicates a position on the grid by cell numbers (column and row).
///
typedef GridPos = ({int col, int row});

///
/// Indicates a line on the grid by [GridPos] from and to.
///
typedef GridLine = ({GridPos from, GridPos to});

///
/// Game status (or state).
///
enum GameStatus {
  none,
  playing,
  winner,
  draw,
}

class GameController {
  ///
  /// Game grid size.
  ///
  int get gridSize => _gridSize;
  int _gridSize = 3;

  ///
  /// First player to perform an action.
  ///
  GameTickType _firstPlayer = GameTickType.cross;

  ///
  /// Stream of the grid values.
  ///
  ValueStream<List<List<GameTickType>>> get gridStream => _gridSubject.stream;
  BehaviorSubject<List<List<GameTickType>>> _gridSubject = BehaviorSubject.seeded([]);

  ///
  /// Stream of the current player playing.
  ///
  ValueStream<GameTickType> get playerTurnStream => _playerTurnSubject.stream;
  BehaviorSubject<GameTickType> _playerTurnSubject = BehaviorSubject.seeded(GameTickType.none);

  ///
  /// Stream the player who won.
  ///
  ValueStream<GameTickType> get winnerStream => _winnerSubject.stream;
  BehaviorSubject<GameTickType> _winnerSubject = BehaviorSubject.seeded(GameTickType.none);

  ///
  /// Stream the coordinates (as cell numbers) of the winning line on the grid.
  ///
  ValueStream<GridLine?> get winnerLineStream => _winnerLineSubject.stream;
  BehaviorSubject<GridLine?> _winnerLineSubject = BehaviorSubject.seeded(null);

  ///
  /// Stream of the score of the `cross` player.
  ///
  ValueStream<int> get scoreCrossStream => _scoreCrossSubject.stream;
  BehaviorSubject<int> _scoreCrossSubject = BehaviorSubject.seeded(0);

  ///
  /// Stream of the score of the `circle` player.
  ///
  ValueStream<int> get scoreCircleStream => _scoreCircleSubject.stream;
  BehaviorSubject<int> _scoreCircleSubject = BehaviorSubject.seeded(0);

  ///
  /// Stream of the game status.
  ///
  ValueStream<GameStatus> get gameStatusStream => _gameStatusSubject.stream;
  BehaviorSubject<GameStatus> _gameStatusSubject = BehaviorSubject.seeded(GameStatus.none);

  ///
  /// Initialize the game controller.
  ///
  void init() {
    _playerTurnSubject.value = _firstPlayer;
    reset();
  }

  ///
  /// Reset the game controller.
  ///
  void reset() {
    _resetSubjects();
    _generateEmptyGrid();
  }

  ///
  /// Set the game grid size.
  ///
  void setGridSize(int gridSize) {
    _gridSize = gridSize;
  }

  ///
  /// Set the player that place its first tick.
  ///
  void setFirstPlayer(GameTickType tickType) {
    _firstPlayer = tickType;
  }

  ///
  /// Start a new game, do not reset the score and alternate the player to start.
  ///
  void startNewGame() {
    _resetSubjects(soft: true);
    _playerTurnSubject.value = _playerTurnSubject.value.other;
    _generateEmptyGrid();
  }

  ///
  /// Place the player at the given grid position.
  ///
  void placeTickAt(int rowIndex, int colIndex) {
    _setGridValue(rowIndex, colIndex);

    final isDraw = _drawCheck();
    if (isDraw) {
      _gameStatusSubject.value = GameStatus.draw;
      return;
    }

    final winnerLine = _winCheck();
    if (winnerLine != null) {
      _onWinnerFound(winnerLine);
      return;
    }

    _played();
  }

  ///
  /// Generate a brand new grid based on the set grid size.
  ///
  void _generateEmptyGrid() {
    final List<List<GameTickType>> grid = [];

    for (int row = 0; row < _gridSize; row++) {
      final List<GameTickType> newRow = [];
      grid.add(newRow);
      for (int col = 0; col < gridSize; col++) {
        newRow.add(GameTickType.none);
      }
    }

    _gridSubject.add(grid);
  }

  ///
  /// Reset the streams (subjects).
  ///
  /// `soft` is set to true when we don't want to loose the game score history. We don't reset all streams.
  ///
  void _resetSubjects({bool soft = true}) {
    _gridSubject.value = [];
    if (!soft) _playerTurnSubject.value = _firstPlayer;
    _winnerSubject.value = GameTickType.none;
    _winnerLineSubject.value = null;
    _gameStatusSubject.value = GameStatus.none;
  }

  ///
  /// Set the current player at the given position in the grid.
  ///
  void _setGridValue(int rowIndex, int colIndex) {
    if (_gridSubject.value[rowIndex][colIndex] != GameTickType.none) return;

    _gridSubject.value[rowIndex][colIndex] = _playerTurnSubject.value;

    // To trigger a stream refresh (not clean).
    _gridSubject.value = _gridSubject.value;
  }

  ///
  /// Callback when a winner had been found on the grid.
  ///
  void _onWinnerFound(GridLine winnerLine) {
    _winnerSubject.value = _playerTurnSubject.value;
    _winnerLineSubject.value = winnerLine;
    _gameStatusSubject.value = GameStatus.winner;
    final winner = _winnerSubject.value;
    if (winner == GameTickType.circle) {
      _scoreCircleSubject.value = _scoreCircleSubject.value + 1;
    } else {
      _scoreCrossSubject.value = _scoreCrossSubject.value + 1;
    }
  }

  ///
  /// Callback when a player has played.
  ///
  /// It changes the player to play.
  ///
  void _played() {
    _playerTurnSubject.value = _playerTurnSubject.value.other;
  }

  ///
  /// Check if there is a winner on the current grid.
  ///
  GridLine? _winCheck() {
    final grid = _gridSubject.value;

    // --- Horizontal check ---
    int lastRow = 0;
    int lastCol = 0;
    for (int row = 0; row < _gridSize; row++) {
      GameTickType first = grid[row][0];
      if (first == GameTickType.none) continue;
      bool allSame = true;
      for (int col = 1; col < _gridSize; col++) {
        if (grid[row][col] != first) {
          allSame = false;
          break;
        }
        lastRow = row;
        lastCol = col;
      }
      if (allSame)
        return (
          from: (col: 0, row: lastRow),
          to: (col: gridSize - 1, row: lastRow),
        );
    }

    // --- Vertical check ---
    for (int col = 0; col < _gridSize; col++) {
      GameTickType first = grid[0][col];
      if (first == GameTickType.none) continue;
      bool allSame = true;
      for (int row = 1; row < _gridSize; row++) {
        if (grid[row][col] != first) {
          allSame = false;
          break;
        }
        lastRow = row;
        lastCol = col;
      }
      if (allSame) {
        return (
          from: (col: lastCol, row: 0),
          to: (col: lastCol, row: gridSize - 1),
        );
      }
    }

    // --- Diagonal check (top-left to bottom-right) ---
    GameTickType firstMainDiagonal = grid[0][0];
    if (firstMainDiagonal != GameTickType.none) {
      bool allSame = true;
      for (int i = 1; i < _gridSize; i++) {
        if (grid[i][i] != firstMainDiagonal) {
          allSame = false;
          break;
        }
      }
      if (allSame) {
        return (
          from: (col: 0, row: 0),
          to: (col: gridSize - 1, row: gridSize - 1),
        );
      }
    }

    // --- Diagonal check (top-right to bottom-left) ---
    GameTickType firstAntiDiagonal = grid[0][_gridSize - 1];
    if (firstAntiDiagonal != GameTickType.none) {
      bool allSame = true;
      for (int i = 1; i < _gridSize; i++) {
        if (grid[i][_gridSize - i - 1] != firstAntiDiagonal) {
          allSame = false;
          break;
        }
      }
      if (allSame) {
        return (
          from: (col: 0, row: gridSize - 1),
          to: (col: gridSize - 1, row: 0),
        );
      }
    }

    // --- No winning line found ---
    return null;
  }

  ///
  /// Check if there is no space left in the grid.
  ///
  bool _drawCheck() {
    return !_gridSubject.value.any((r) => r.any((c) => c == GameTickType.none));
  }
}

final GameController gameController = GameController();
