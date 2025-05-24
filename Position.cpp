#include "Position.h"



Position::Position() = default;
Position::Position(const std::string& shortFen, uint8_t enPassant, bool wlCastling, bool wsCastling, bool blCastling, bool bsCastling, float moveCtr) {
    this->pieces = { shortFen };
    this->enPassant = enPassant;

    this->wlCastling = wlCastling;
    this->wsCastling = wsCastling;
    this->blCastling = blCastling;
    this->bsCastling = bsCastling;

    this->moveCtr = moveCtr;
    this->hash = { this->pieces, this->blackToMove(), this->wlCastling, this->wsCastling, this->blCastling, this->bsCastling };
    this->repetitionHistory.addPosition(this->hash);
    this->fiftyMovesCtr = 0;
    std::cout << "Created position with:" << std::endl;
    std::cout << "- " << BOp::count1(this->pieces.getPieceBitboard(SIDE::WHITE, PIECE::PAWN)) << " white pawns" << std::endl;
    std::cout << "- " << BOp::count1(this->pieces.getPieceBitboard(SIDE::BLACK, PIECE::PAWN)) << " black pawns" << std::endl;
    std::cout << "- " << BOp::count1(this->pieces.getPieceBitboard(SIDE::WHITE, PIECE::KING)) << " white king" << std::endl;
    std::cout << "- " << BOp::count1(this->pieces.getPieceBitboard(SIDE::BLACK, PIECE::KING)) << " black king" << std::endl;
    std::cout << "Total pieces: " << BOp::count1(this->pieces.getAllBitboard()) << std::endl;
}
std::ostream& operator<<(std::ostream& ostream, const Position& position) {
    ostream << position.pieces << "\n";

    ostream << "En passant: " << (uint32_t)position.enPassant << "\n";
    ostream << "White long castling: " << position.wlCastling << "\n";
    ostream << "White short castling: " << position.wsCastling << "\n";
    ostream << "Black long castling: " << position.blCastling << "\n";
    ostream << "Black short castling: " << position.blCastling << "\n";
    ostream << "Move counter: " << position.moveCtr << "\n";
    ostream << "Zobrist value: " << std::hex << "0x" << position.hash.getValue() << "\n" << std::dec;
    ostream << "Fifty moves counter: " << position.fiftyMovesCtr << "\n";
    ostream << "Threefold repetition counter: " << (uint32_t)position.repetitionHistory.getRepetitionNumber(position.hash);

    return ostream;
}
void Position::move(Move move) {
    this->removePiece(move.getFrom(), move.getAttackerType(), move.getAttackerSide());
    this->addPiece(move.getTo(), move.getAttackerType(), move.getAttackerSide());
    if (move.getDefenderType() != Move::NONE) {
        this->removePiece(move.getTo(), move.getDefenderType(), move.getDefenderSide());
    }

    switch (move.getFlag()) {
    case Move::FLAG::DEFAULT:
        break;

    case Move::FLAG::PAWN_LONG_MOVE:
        this->changeEnPassant((move.getFrom() + move.getTo()) / 2);
        break;
    case Move::FLAG::EN_PASSANT_CAPTURE:
        if (move.getAttackerSide() == SIDE::WHITE) {
            this->removePiece(move.getTo() - 8, PIECE::PAWN, SIDE::BLACK);
        }
        else {
            this->removePiece(move.getTo() + 8, PIECE::PAWN, SIDE::WHITE);
        }
        break;

    case Move::FLAG::WL_CASTLING:
        this->removePiece(0, PIECE::ROOK, SIDE::WHITE);
        this->addPiece(3, PIECE::ROOK, SIDE::WHITE);
        break;
    case Move::FLAG::WS_CASTLING:
        this->removePiece(7, PIECE::ROOK, SIDE::WHITE);
        this->addPiece(5, PIECE::ROOK, SIDE::WHITE);
        break;
    case Move::FLAG::BL_CASTLING:
        this->removePiece(56, PIECE::ROOK, SIDE::BLACK);
        this->addPiece(59, PIECE::ROOK, SIDE::BLACK);
        break;
    case Move::FLAG::BS_CASTLING:
        this->removePiece(63, PIECE::ROOK, SIDE::BLACK);
        this->addPiece(61, PIECE::ROOK, SIDE::BLACK);
        break;

    case Move::FLAG::PROMOTE_TO_KNIGHT:
        this->removePiece(move.getTo(), PIECE::PAWN, move.getAttackerSide());
        this->addPiece(move.getTo(), PIECE::KNIGHT, move.getAttackerSide());
        break;
    case Move::FLAG::PROMOTE_TO_BISHOP:
        this->removePiece(move.getTo(), PIECE::PAWN, move.getAttackerSide());
        this->addPiece(move.getTo(), PIECE::BISHOP, move.getAttackerSide());
        break;
    case Move::FLAG::PROMOTE_TO_ROOK:
        this->removePiece(move.getTo(), PIECE::PAWN, move.getAttackerSide());
        this->addPiece(move.getTo(), PIECE::ROOK, move.getAttackerSide());
        break;
    case Move::FLAG::PROMOTE_TO_QUEEN:
        this->removePiece(move.getTo(), PIECE::PAWN, move.getAttackerSide());
        this->addPiece(move.getTo(), PIECE::QUEEN, move.getAttackerSide());
        break;
    }

    this->pieces.updateBitboards();

    if (move.getFlag() != Move::FLAG::PAWN_LONG_MOVE) {
        this->changeEnPassant(Position::NONE);
    }

    switch (move.getFrom()) {
    case 0:
        this->removeWLCastling();
        break;
    case 4:
        this->removeWLCastling();
        this->removeWSCastling();
        break;
    case 7:
        this->removeWSCastling();
        break;
    case 56:
        this->removeBLCastling();
        break;
    case 60:
        this->removeBLCastling();
        this->removeBSCastling();
        break;
    case 63:
        this->removeBSCastling();
        break;
    }

    this->updateMoveCtr();

    this->updateFiftyMovesCtr(move.getAttackerType() == PIECE::PAWN or move.getDefenderType() != Move::NONE);

    if (move.getAttackerType() == PIECE::PAWN or move.getDefenderType() != Move::NONE) {
        this->repetitionHistory.clear();
    }
    this->repetitionHistory.addPosition(this->hash);
}
Pieces Position::getPieces() const {
    return this->pieces;
}
uint8_t Position::getEnPassant() const {
    return this->enPassant;
}
bool Position::getWLCastling() const {
    return this->wlCastling;
}
bool Position::getWSCastling() const {
    return this->wsCastling;
}
bool Position::getBLCastling() const {
    return this->blCastling;
}
bool Position::getBSCastling() const {
    return this->bsCastling;
}
bool Position::whiteToMove() const {
    return !this->blackToMove();
}
bool Position::blackToMove() const {
    return (this->moveCtr - std::floor(this->moveCtr) > 1e-4);
}
ZobristHash Position::getHash() const {
    return this->hash;
}
bool Position::fiftyMovesRuleDraw() const {
    return (this->fiftyMovesCtr == 50);
}
bool Position::threefoldRepetitionDraw() const {
    return (this->repetitionHistory.getRepetitionNumber(this->hash) == 3);
}
void Position::addPiece(uint8_t square, uint8_t type, uint8_t side) {
    if (!BOp::getBit(this->pieces.getPieceBitboard(side, type), square)) {
        this->pieces.setPieceBitboard(side, type, BOp::set1(this->pieces.getPieceBitboard(side, type), square));
        this->hash.invertPiece(square, type, side);
    }
}
void Position::removePiece(uint8_t square, uint8_t type, uint8_t side) {
    if (BOp::getBit(this->pieces.getPieceBitboard(side, type), square)) {
        this->pieces.setPieceBitboard(side, type, BOp::set0(this->pieces.getPieceBitboard(side, type), square));
        this->hash.invertPiece(square, type, side);
    }
}
void Position::changeEnPassant(uint8_t en_passant) {
    this->enPassant = en_passant;
}
void Position::removeWLCastling() {
    if (this->wlCastling) {
        this->wlCastling = false;
        this->hash.invertWLCastling();
    }
}
void Position::removeWSCastling() {
    if (this->wsCastling) {
        this->wsCastling = false;
        this->hash.invertWSCastling();
    }
}
void Position::removeBLCastling() {
    if (this->blCastling) {
        this->blCastling = false;
        this->hash.invertBLCastling();
    }
}
void Position::removeBSCastling() {
    if (this->bsCastling) {
        this->bsCastling = false;
        this->hash.invertBSCastling();
    }
}
void Position::updateMoveCtr() {
    this->moveCtr = this->moveCtr + 0.5f;
    this->hash.invertMove();
}
void Position::updateFiftyMovesCtr(bool breakEvent) {
    if (breakEvent) {
        this->fiftyMovesCtr = 0;
    }
    else {
        this->fiftyMovesCtr = this->fiftyMovesCtr + 0.5f;
    }
}
bool Position::insufficientMaterialDraw() const {
    Bitboard allPieces = pieces.getAllBitboard();
    int pieceCount = BOp::count1(allPieces);

    // Только короли
    if (pieceCount == 2) return true;

    // K+N vs K или K+B vs K
    if (pieceCount == 3) {
        Bitboard knights = pieces.getPieceBitboard(SIDE::WHITE, PIECE::KNIGHT) |
                           pieces.getPieceBitboard(SIDE::BLACK, PIECE::KNIGHT);
        Bitboard bishops = pieces.getPieceBitboard(SIDE::WHITE, PIECE::BISHOP) |
                           pieces.getPieceBitboard(SIDE::BLACK, PIECE::BISHOP);

        if (BOp::count1(knights) == 1 || BOp::count1(bishops) == 1) {
            return true;
        }
    }

    // K+NN vs K (два коня против короля)
    if (pieceCount == 4) {
        Bitboard whiteKnights = pieces.getPieceBitboard(SIDE::WHITE, PIECE::KNIGHT);
        Bitboard blackKnights = pieces.getPieceBitboard(SIDE::BLACK, PIECE::KNIGHT);

        // Если у белых два коня и больше нет других фигур кроме короля
        if (BOp::count1(whiteKnights) == 2 &&
            BOp::count1(pieces.getSideBitboard(SIDE::WHITE)) == 3 &&
            BOp::count1(pieces.getSideBitboard(SIDE::BLACK)) == 1) {
            return true;
        }

        // Если у черных два коня и больше нет других фигур кроме короля
        if (BOp::count1(blackKnights) == 2 &&
            BOp::count1(pieces.getSideBitboard(SIDE::BLACK)) == 3 &&
            BOp::count1(pieces.getSideBitboard(SIDE::WHITE)) == 1) {
            return true;
        }
    }

    // K+B vs K+B, где слоны ходят по полям одного цвета
    if (pieceCount == 4) {
        Bitboard whiteBishops = pieces.getPieceBitboard(SIDE::WHITE, PIECE::BISHOP);
        Bitboard blackBishops = pieces.getPieceBitboard(SIDE::BLACK, PIECE::BISHOP);

        if (BOp::count1(whiteBishops) == 1 && BOp::count1(blackBishops) == 1 &&
            BOp::count1(pieces.getSideBitboard(SIDE::WHITE)) == 2 &&
            BOp::count1(pieces.getSideBitboard(SIDE::BLACK)) == 2) {

            // Определяем цвет полей под слонами
            // Слон на четном поле (белом) если сумма координат x+y четная
            // Слон на нечетном поле (черном) если сумма координат x+y нечетная
            uint8_t whiteBishopIndex = BOp::bsf(whiteBishops);
            uint8_t blackBishopIndex = BOp::bsf(blackBishops);

            bool whiteOnWhite = ((whiteBishopIndex % 8) + (whiteBishopIndex / 8)) % 2 == 0;
            bool blackOnWhite = ((blackBishopIndex % 8) + (blackBishopIndex / 8)) % 2 == 0;

            // Если слоны на полях одного цвета - ничья
            if (whiteOnWhite == blackOnWhite) {
                return true;
            }
        }
    }

    // Проверяем, что на доске нет пешек, ферзей и ладей
    bool hasPawns = pieces.getPieceBitboard(SIDE::WHITE, PIECE::PAWN) ||
                    pieces.getPieceBitboard(SIDE::BLACK, PIECE::PAWN);
    bool hasQueens = pieces.getPieceBitboard(SIDE::WHITE, PIECE::QUEEN) ||
                     pieces.getPieceBitboard(SIDE::BLACK, PIECE::QUEEN);
    bool hasRooks = pieces.getPieceBitboard(SIDE::WHITE, PIECE::ROOK) ||
                    pieces.getPieceBitboard(SIDE::BLACK, PIECE::ROOK);

    if (!hasPawns && !hasQueens && !hasRooks) {
        // Остались только короли, кони и слоны

        // Если у обоих игроков только по одному слону
        Bitboard whiteBishops = pieces.getPieceBitboard(SIDE::WHITE, PIECE::BISHOP);
        Bitboard blackBishops = pieces.getPieceBitboard(SIDE::BLACK, PIECE::BISHOP);

        if (BOp::count1(whiteBishops) <= 1 && BOp::count1(blackBishops) <= 1) {
            // Если нет коней - уже проверено выше
            // Если есть кони, нужны дополнительные проверки
            Bitboard whiteKnights = pieces.getPieceBitboard(SIDE::WHITE, PIECE::KNIGHT);
            Bitboard blackKnights = pieces.getPieceBitboard(SIDE::BLACK, PIECE::KNIGHT);

            // Один конь и один слон могут поставить мат, но два коня без других фигур - нет
            // Если у стороны только 2+ коня без слона и пешек - недостаточно материала
            if ((BOp::count1(whiteKnights) >= 2 && BOp::count1(whiteBishops) == 0 &&
                 BOp::count1(pieces.getSideBitboard(SIDE::WHITE)) == BOp::count1(whiteKnights) + 1) ||
                (BOp::count1(blackKnights) >= 2 && BOp::count1(blackBishops) == 0 &&
                 BOp::count1(pieces.getSideBitboard(SIDE::BLACK)) == BOp::count1(blackKnights) + 1)) {
                return true;
            }
        }
    }

    return false;
}
