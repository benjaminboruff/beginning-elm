var multiplier = 2;
var scores = [316, 320, 312, 370, 337, 318, 314];

function doubleScores(scores) {
    for (var i = 0; i < scores.length; i++) {
        scores[i] = scores[i] * multiplier;
    }

    return scores;
}

function scoresLessThan320(scores) {
    return scores.filter(isLessThan320);
}

function isLessThan320(score) {
    return score < 320;
}