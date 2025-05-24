#include "PsLegalMoveMaskGen.h"
#include "PassedPawnMasks.h"


#pragma once


class StaticEvaluator {
public:
    static int32_t evaluate(Pieces pieces, bool showDebugInfo = false);
private:
    static int32_t material(Pieces pieces);
    static int32_t mobility(Pieces pieces);
    static int32_t doublePawn(Pieces pieces);
    static int32_t connectedPawn(Pieces pieces);
    static int32_t pawnPromotion(Pieces pieces);
    static int32_t kingSafety(Pieces pieces);
    static int32_t endgame(Pieces pieces, bool whiteStronger);

    struct MATERIAL {
        static constexpr int32_t PAWN = 100;
        static constexpr int32_t KNIGHT = 300;
        static constexpr int32_t BISHOP = 325;
        static constexpr int32_t ROOK = 550;
        static constexpr int32_t QUEEN = 950;
    };
    struct MOBILITY {
        static constexpr int32_t KNIGHT = 12;
        static constexpr int32_t BISHOP = 8;
        static constexpr int32_t ROOK = 5;
        static constexpr int32_t QUEEN = 5;
    };
    struct PAWN_STRUCTURE {
        static constexpr int32_t DOUBLE_PAWN = -25;
        static constexpr int32_t CONNECTED_PAWN = 10;
        static constexpr std::array<int32_t, 8> DEFAULT_PAWN_PROMOTION = { 0, 0, 0, 0, 10, 20, 30, 0 };
        static constexpr std::array<int32_t, 8> PASSED_PAWN_PROMOTION = { 0, 50, 50, 50, 70, 90, 110, 0 };
    };
    struct KING_SAFETY {
        static constexpr int32_t KNIGHT = 25;
        static constexpr int32_t BISHOP = 25;
        static constexpr int32_t ROOK = 25;
        static constexpr int32_t QUEEN = 50;
    };
    struct ENDGAME {
        static constexpr int32_t MAXIMUM_PIECES_FOR_ENDGAME = 8;
        static constexpr int32_t PROXIMITY_KINGS = 10;
        static constexpr int32_t DISTANCE_WEAK_KING_MIDDLE = 10;
    };

    friend class MoveSorter;
};