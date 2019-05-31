load hald; %??matlab????
[pc,score,latent,tsquare] = princomp(ingredients);

cov_ingredients=cov(ingredietns);

[vector, value]=eig(cov_ingredients);
