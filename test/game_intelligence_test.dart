import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/controllers/game_controller.dart';
import 'package:tic_tac_toe/controllers/game_intelligence_controller.dart';

void main() {
  late GameIntelligenceController controller;

  /// Builds a 3x3 grid from a string: 'C' = cross, 'O' = circle, '.' = none.
  /// Rows are separated by spaces, e.g. "C.O .C. ..."
  List<List<GameTickType>> gridFrom(String s) {
    final rows = s.split(' ').map((row) => row.split(''));
    final grid = <List<GameTickType>>[];
    for (final row in rows) {
      grid.add(
        row.map((c) {
          switch (c) {
            case 'C':
              return GameTickType.cross;
            case 'O':
              return GameTickType.circle;
            default:
              return GameTickType.none;
          }
        }).toList(),
      );
    }
    return grid;
  }

  group('getNextMove', () {
    group('win when possible', () {
      test('AI (circle) completes horizontal row', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('OO. ... ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 2, row: 0));
      });

      test('AI (circle) completes vertical column', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.. O.. ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 0, row: 2));
      });

      test('AI (circle) completes main diagonal', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.. .O. ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 2, row: 2));
      });

      test('AI (circle) completes anti-diagonal', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('..C .C. ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 0, row: 2));
      });
    });

    group('block when opponent can win', () {
      test('AI (circle) blocks horizontal win for cross', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('CC. ... ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 2, row: 0));
      });

      test('AI (circle) blocks vertical win for cross', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('C.. C.. ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 0, row: 2));
      });

      test('AI (circle) blocks diagonal win for cross', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.. .O. ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 2, row: 2));
      });
    });

    group('algorithm step 0: first move corner', () {
      test('empty grid returns a corner', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('... ... ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, isNotNull);
        expect(move!.col % 2, 0, reason: 'col should be 0 or 2');
        expect(move.row % 2, 0, reason: 'row should be 0 or 2');
      });

      test('empty grid returns one of the four corners', () {
        const corners = [(0, 0), (2, 0), (0, 2), (2, 2)];
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('... ... ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, isNotNull);
        final isCorner = corners.any((c) => c.$1 == move!.col && c.$2 == move.row);
        expect(isCorner, isTrue);
      });

      test('first move (0 AI pieces) returns a corner', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('... ... ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, isNotNull);
        expect(move!.col % 2, 0);
        expect(move.row % 2, 0);
      });
    });

    group('second move (1 AI piece): opposite corner or block', () {
      test('takes opposite corner when free (AI at 0,0, opponent took center)', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.. .C. ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 2, row: 2));
      });

      test('when opposite corner is taken, plays middle of opponent row or column', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.. ... ..C');
        final move = controller.getNextMove(
          grid,
          opponentLastMove: (col: 2, row: 2),
        );
        expect(move, isNotNull);
        final validStep1Block = move == (col: 1, row: 2) || move == (col: 2, row: 1);
        expect(validStep1Block, isTrue, reason: 'step 1 fallback should play middle of row or col');
        expect(grid[move!.row][move.col], GameTickType.none);
      });

      test('when AI has one piece and opposite corner is free, takes opposite corner', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.. .C. ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 2, row: 2));
      });
    });

    group('third move (2 AI pieces): take center', () {
      test('takes center when free', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.. ... ..O');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 1, row: 1));
      });

      test('when center is taken with 2 AI pieces, falls through to win/block/random', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.C CO. ..C');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, isNotNull);
        expect(grid[move!.row][move.col], GameTickType.none);
      });
    });

    group('algorithm step progression', () {
      test('full sequence: first move corner, then opposite, then center', () {
        controller = GameIntelligenceController(gridSize: 3);
        final empty = gridFrom('... ... ...');

        final move0 = controller.getNextMove(empty, opponentLastMove: null);
        expect(move0, isNotNull);
        expect(move0!.col % 2, 0);
        expect(move0.row % 2, 0);

        final gridAfter0 = gridFrom('... ... ...');
        gridAfter0[move0.row][move0.col] = GameTickType.circle;
        gridAfter0[1][1] = GameTickType.cross;
        final move1 = controller.getNextMove(gridAfter0, opponentLastMove: null);
        final oppositeCol = (move0.col - 2).abs();
        final oppositeRow = (move0.row - 2).abs();
        expect(move1, (col: oppositeCol, row: oppositeRow));

        final gridAfter1 = gridFrom('... ... ...');
        gridAfter1[move0.row][move0.col] = GameTickType.circle;
        gridAfter1[oppositeRow][oppositeCol] = GameTickType.circle;
        gridAfter1[0][1] = GameTickType.cross;
        gridAfter1[1][0] = GameTickType.cross;
        final move2 = controller.getNextMove(gridAfter1, opponentLastMove: null);
        expect(move2, (col: 1, row: 1));
      });
    });

    group('valid move when no win/block', () {
      test('returned cell is empty', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('OC. C.. ...');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, isNotNull);
        expect(grid[move!.row][move.col], GameTickType.none);
      });

      test('one empty cell returns that cell', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('O.C COO CCO');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, (col: 1, row: 0));
      });
    });

    group('edge cases', () {
      test('full grid returns null', () {
        controller = GameIntelligenceController(gridSize: 3);
        final grid = gridFrom('OCC COO CCC');
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, isNull);
      });

      test('non-3x3 grid returns null', () {
        controller = GameIntelligenceController(gridSize: 4);
        final grid = [
          [GameTickType.none, GameTickType.none, GameTickType.none, GameTickType.none],
          [GameTickType.none, GameTickType.none, GameTickType.none, GameTickType.none],
          [GameTickType.none, GameTickType.none, GameTickType.none, GameTickType.none],
          [GameTickType.none, GameTickType.none, GameTickType.none, GameTickType.none],
        ];
        final move = controller.getNextMove(grid, opponentLastMove: null);
        expect(move, isNull);
      });
    });
  });

  group('checkWin', () {
    test('no winner on empty grid', () {
      controller = GameIntelligenceController(gridSize: 3);
      final grid = gridFrom('... ... ...');
      expect(controller.checkWin(grid), isNull);
    });

    test('horizontal win', () {
      controller = GameIntelligenceController(gridSize: 3);
      final grid = gridFrom('OOO ... ...');
      final line = controller.checkWin(grid);
      expect(line, isNotNull);
      expect(line!.from, (col: 0, row: 0));
      expect(line.to, (col: 2, row: 0));
    });

    test('vertical win', () {
      controller = GameIntelligenceController(gridSize: 3);
      final grid = gridFrom('C.. C.. C..');
      final line = controller.checkWin(grid);
      expect(line, isNotNull);
      expect(line!.from, (col: 0, row: 0));
      expect(line.to, (col: 0, row: 2));
    });

    test('diagonal win', () {
      controller = GameIntelligenceController(gridSize: 3);
      final grid = gridFrom('C.. .C. ..C');
      final line = controller.checkWin(grid);
      expect(line, isNotNull);
      expect(line!.from, (col: 0, row: 0));
      expect(line.to, (col: 2, row: 2));
    });
  });
}
