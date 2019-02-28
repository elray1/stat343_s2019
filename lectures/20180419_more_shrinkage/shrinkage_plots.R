library(rgl)
library(mvtnorm)
library(plyr)
library(dplyr)

X1 <- unexpanded_X <- seq(from = -3, to = 3, length = 101)
X2 <- unexpanded_Y <- seq(from = -3, to = 3, length = 101)
plot_df <- as.data.frame(expand.grid(X = unexpanded_X, Y = unexpanded_Y))
plot_df_0 <- plot_df_0.5 <- plot_df_0.9 <- plot_df

plot_df_0$joint_density <- dmvnorm(plot_df, sigma = matrix(c(1, 0, 0, 1), nrow = 2, ncol = 2))
plot_df_0.5$joint_density <- dmvnorm(plot_df, sigma = matrix(c(1, -0.5, -0.5, 1), nrow = 2, ncol = 2))
plot_df_0.9$joint_density <- dmvnorm(plot_df, sigma = matrix(c(1, 0.9, 0.9, 1), nrow = 2, ncol = 2))

color_n <- 1000 # number of colors used

joint_density_lim <- range(c(plot_df_0$joint_density, plot_df_0.5$joint_density, plot_df_0.9$joint_density))
joint_density_range <- joint_density_lim[2] - joint_density_lim[1]
joint_density_colorlut <- rev(rainbow(1000, start = 0, end = 4/6)) # height color lookup table
joint_density_col_0 <- joint_density_colorlut[ floor(color_n * (plot_df_0$joint_density - joint_density_lim[1])/joint_density_range) + 1 ]
joint_density_col_0.5 <- joint_density_colorlut[ floor(color_n * (plot_df_0.5$joint_density - joint_density_lim[1])/joint_density_range) + 1 ]
joint_density_col_0.9 <- joint_density_colorlut[ floor(color_n * (plot_df_0.9$joint_density - joint_density_lim[1])/joint_density_range) + 1 ]

junk <- open3d()
z_max <- joint_density_lim[2]
plot3d(X1, X2, xlim=c(-3, 3), ylim=c(-3, 3), zlim=c(0, z_max), zlab="f(x_1, x_2)", mouseMode = "zAxis", type = "s")
surface3d(X1, X2, plot_df_0$joint_density, alpha = 0.3, col = joint_density_col_0)

junk <- open3d()
z_max <- joint_density_lim[2]
plot3d(X1, X2, xlim=c(-3, 3), ylim=c(-3, 3), zlim=c(0, z_max), zlab="f(x_1, x_2)", mouseMode = "zAxis", type = "s")
surface3d(X1, X2, plot_df_0.5$joint_density, alpha = 0.3, col = joint_density_col_0.5)

junk <- open3d()
z_max <- joint_density_lim[2]
plot3d(X1, X2, xlim=c(-3, 3), ylim=c(-3, 3), zlim=c(0, z_max), zlab="f(x_1, x_2)", mouseMode = "zAxis", type = "s")
surface3d(X1, X2, plot_df_0.9$joint_density, alpha = 0.3, col = joint_density_col_0.9)


#rgl.viewpoint(userMatrix = matrix(c(0.921660840511322, 0.0465770699083805, -0.385190784931183, 0, -0.387880355119705, 0.0862834379076958, -0.917662262916565, 0, -0.00950636342167854, 0.995181322097778, 0.0975903198122978, 0, 0, 0, 0, 1), nrow = 4))


#slice_at_z_eq_0.1 <- plot_df[abs(plot_df$joint_density - 0.1) < 0.001, 1:3]
#names(slice_at_z_eq_0.1) <- c("x", "y", "z")
#slice_x_range <- range(slice_at_z_eq_0.1$x)
#lines3d(slice_at_z_eq_0.1 %>% arrange(x, y))

#snapshot3d("/media/evan/data/Evan/photos/normal_cond_dist_view1.bmp")

rgl.postscript("~/teaching/2018-spring-stat343/stat343_s2018/lectures/20180417_shrinkage/mvn_5.pdf","pdf")

rgl.viewpoint(userMatrix = matrix(c(0.921660840511322, 0.0465770699083805, -0.385190784931183, 0, -0.387880355119705, 0.0862834379076958, -0.917662262916565, 0, -0.00950636342167854, 0.995181322097778, 0.0975903198122978, 0, 0, 0, 0, 1), nrow = 4))


junk <- open3d()
plot3d(ellipse3d(x = matrix(c(1, .3, .6, .3, 2, 1.1, .6, 1.1, 3), nrow = 3), scale = rep(1, 3), centre = c(0, 0, 0), t = 3), type = "wire", col = "blue", alpha = 0.2, add = TRUE)
plot3d(ellipse3d(x = matrix(c(1, .3, .6, .3, 2, 1.1, .6, 1.1, 3), nrow = 3), scale = rep(1, 3), centre = c(0, 0, 0), t = 2), type = "wire", col = "yellow", alpha = 0.2, add = TRUE)
plot3d(ellipse3d(x = matrix(c(1, .3, .6, .3, 2, 1.1, .6, 1.1, 3), nrow = 3), scale = rep(1, 3), centre = c(0, 0, 0), t = 1), type = "wire", col = "red", alpha = 0.2, add = TRUE)
decorate3d()
rgl.viewpoint(userMatrix = matrix(c(0.921660840511322, 0.0465770699083805, -0.385190784931183, 0, -0.387880355119705, 0.0862834379076958, -0.917662262916565, 0, -0.00950636342167854, 0.995181322097778, 0.0975903198122978, 0, 0, 0, 0, 1), nrow = 4))

eo <- ellipse3d(x = diag(0.5, nrow = 3), scale = rep(1, 3), centre = c(2, 3, 5), t = 3)
eo <- ellipse3d(x = diag(1, nrow = 3), scale = rep(1, 3), centre = c(1, 1, 1), t = 1)

edef <- eo
for(j in seq_len(ncol(edef$vb))) {
  edef$vb[1:3, j] <- (1 - 1 / sum((edef$vb[1:3, j])^2)) * edef$vb[1:3, j]
}

edef2 <- qmesh3d(vertices = edef$vb, indices = edef$ib)
edef3 <- qmesh3d(vertices = as.numeric(edef$vb[1:3, ]), indices = as.integer(edef$ib))

edef4 <- ellipse3d(x = diag(1, nrow = 3), scale = rep(1, 3), centre = c(0, 0, 0), t = 1)

junk <- open3d()
plot3d(eo, alpha = 0.2, type = "wire")
plot3d(edef, alpha = 0.2, type = "wire", col = "blue", add = TRUE)
#plot3d(edef, alpha = 0.2, col = "blue")
plot3d(edef2, alpha = 0.2, col = "red", add = TRUE)
plot3d(edef3, alpha = 0.2, col = "red", add = TRUE)
plot3d(edef4, alpha = 0.2, col = "purple", add = TRUE)
#plot3d(edef2, alpha = 0.2, col = "red")

eo_subset <- eo
eo_subset$ib <- eo_subset$ib[, 1, drop = FALSE]
edef3_subset <- edef3
edef3_subset$ib <- edef3_subset$ib[, 1, drop = FALSE]

edef5 <- qmesh3d(vertices = as.numeric(edef3$vb[, c(1, 195, 99, 196)]), indices = 1:4)
edef6 <- tmesh3d(vertices = as.numeric(edef$vb[]), indices = cbind(edef$ib[1:3, ], edef3$ib[2:4, ]))
edef6_subset <- edef6
edef6_subset$it <- edef6_subset$it[, 1, drop = FALSE]

junk <- open3d()
plot3d(edef6_subset, alpha = 0.2, col = "red")
#plot3d(eo, alpha = 0.2, type = "wire")
plot3d(edef6, alpha = 0.2, col = "red")
plot3d(edef6, alpha = 0.2, col = "red", add = TRUE)

edef7 <- tmesh3d(vertices = as.numeric(edef$vb[, edef6_subset$it]), indices = c(1, 2, 3))
junk <- open3d()
plot3d(edef7, alpha = 0.2, col = "red")
#plot3d(eo, alpha = 0.2, type = "wire")
plot3d(edef6, alpha = 0.2, col = "red")
plot3d(edef6, alpha = 0.2, col = "red", add = TRUE)


junk <- open3d()
plot3d(eo_subset, alpha = 0.2, type = "wire")
plot3d(edef6, alpha = 0.2, col = "red", add = TRUE)
#plot3d(edef, alpha = 0.2, type = "wire", col = "blue", add = TRUE)
#plot3d(edef, alpha = 0.2, col = "blue")
#plot3d(edef2, alpha = 0.2, col = "red", add = TRUE)
#plot3d(edef3_subset, alpha = 0.2, col = "red", add = TRUE)
#plot3d(edef4, alpha = 0.2, col = "purple", add = TRUE)
plot3d(edef5, alpha = 0.2, col = "purple", add = TRUE)
