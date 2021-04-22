regressions
        eigenvector.frug ~ Size + Morphology

        # latent variables
        Size =~ Mass + Forearm
        Morphology =~ LMT + BUM

        # covariances and variances
        Mass ~~ Mass
        Forearm ~~ Forearm
        LMT ~~ LMT
        BUM ~~ BUM
