# Worm_Recognization
Identify worms in different images

There are four tasks in this project.
Task1 and task2 are based on the merged images(see in Original_images). Task3 and task4 are based on the unmerged images(see in Original_images/new/batchA#). 

# Merged Images
task1_compare.m: Identify worms based on features for merged images. This should be run after task1_feature_find_omega.m.

task1_extract_features.m: Extract features for merged images. This should be run after task1_extract_pictures.m.

task1_extract_pictures.m: Extract worm areas for merged images. This should be run first.

task1_feature_find_omega.m: Find optimal weights for merged images. This should be run after task1_extract_features.m.

task2_show_thresholds.m: Show features' change for different thresholds. This should be run after task1_extract_features.m.

# Unmerged Images
task3_extract_features.m: Extract features for unmerged images. This should be run after task3_extract_pictures.m.

task3_extract_pictures.m: Extract worm areas for unmerged images. This should be run first.

task3_show.m: Show features' change for different thresholds. This should be run after task3_extract_features.m.

task4_find_weights.m: Find the optimal weights for unmerged images. This should be run after task4_rebuild_data.m.

task4_rebuild_data.m: Rerun extracting process until there is no breakpoints. This should be run first.
