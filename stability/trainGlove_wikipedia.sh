#!/bin/bash
# Create five GloVe embedding spaces (downsampling without replacement) for each language in Wikipedia.

# SET THESE VARIABLES

# Location of the Wikipedia data
# Can be downloaded from https://sites.google.com/site/rmyeid/projects/polyglot
# Before running this code, for each language, you need to create five downsamples (without replacement).


# Location where output embedding spaces will be stored
# For each embedding space, multiple files will be created:
# A vocab file, stored as {output_path}{language}/downsampled_without_replacement_glove_vocab_{downsample_index}.txt
# A coocurrence file, stored as {output_path}{language}/downsampled_without_replacement_glove_coocurrence_{downsample_index}.bin
# A shuffled coocurrence file, stored as {output_path}{language}/downsampled_without_replacement_glove_coocurrence_{downsample_index}.shuf.bin
# The final embedding space, stored as {output_path}{language}/downsampled_without_replacement_glove_{downsample_index}

# Location of code for GloVe
# Can be downloaded from https://nlp.stanford.edu/projects/glove/
glove_path=/Users/nehakardam/Project-CSE517/GloVe-master

# Languages to create embedding spaces for (can adjust if needed, or leave the same)
languages=(en hi en ar)

# Indices of downsamples to process (can adjust if needed, or leave the same)
# Right now, we are processing five downsamples
indices=(0 1 2 3 4)

# Create embeddings for each language
for language in ${languages[@]};
do
	echo ${language}

	# Create embeddings for each downsample
	for index in ${indices[@]};
	do
		${glove_path}/build/vocab_count -min-count 5 -verbose 2 < /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_${index}.txt > /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_glove_vocab_${index}.txt
		${glove_path}/build/cooccur -verbose 2 -window-size 5 -vocab-file /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_glove_vocab_${index}.txt < /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_${index}.txt > /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_glove_coocurrence_${index}.bin
		${glove_path}/build/shuffle -verbose 2 < /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_glove_coocurrence_${index}.bin > /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_glove_coocurrence_${index}.shuf.bin
		${glove_path}/build/glove -verbose 2 -vector-size 300 -iter 10 -seed 2518 -vocab-file /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_glove_vocab_${index}.txt -input-file /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_glove_coocurrence_${index}.shuf.bin -save-file /Users/nehakardam/Project-CSE517/polyglot/${language}/downsampled_without_replacement_glove_${index}
	done
done
