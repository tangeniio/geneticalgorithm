### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ ca5a9969-dc3d-4154-a2fd-c0057c5650bf
using PlutoUI

# ╔═╡ d9300c0c-f329-49ce-a1eb-fd9a52923709
md"### Defining Genetic Algortihm Structs"

# ╔═╡ ccac7604-7006-41c7-bfea-ccf25ef2cdb5
mutable struct population
	genes
end

# ╔═╡ 312b5890-b172-4c97-bb96-26e092b9d4b4
mutable struct genes
	genePool
	fitness
end

# ╔═╡ 873e0df3-6b7d-441b-95d6-ee09eb5d325c
md"# -----------------------------------------"

# ╔═╡ 647f2f4c-55c0-444c-a804-b54b6c96a588
function maximum(optG)
	max = length(optG)
	return max
end

# ╔═╡ 9bafd5f1-935a-434e-8a30-3415e0eed5a6
function populate(input,size)
	G = Array{genes}(undef, input)
	defaultGenes = rand([1,0],size)
	defaultFitness = 0
	for i = 1:input
		G[i] = genes(defaultGenes,defaultFitness)
	end
	Population = population(G)
end

# ╔═╡ 59ae2a0a-0c3f-47e7-9abd-bdff524dd018
md"### // Fitness Function"

# ╔═╡ 54e2cec7-539a-4e4d-a7d2-901d7598601c
function fitness(gene,optG)
	size = length(gene.genePool)
	gene.fitness = 0
	for i = 1:size
		if gene.genePool[i] == optG[i]
			gene.fitness+=1
		end
	end
	return gene.fitness
end

# ╔═╡ d3612443-07d5-41b4-849d-ec6ac1d053e8
function getFit(P)
	gSize = size(P.genes[1].genePool)
	f = genes(zeros(gSize),0)
	l = length(P.genes)
	for i = 1:l
		
			if f.fitness <= P.genes[i].fitness
				f = P.genes[i]
			end
	end
	return f
end

# ╔═╡ 377a605a-ecd4-4896-a2d3-895a7e1f4230
md"### // Selection Probability"

# ╔═╡ d2efa0ab-63f6-4908-83cf-1e46900eb914
function selection(P)
	poolSize = 5
	size = length(P.genes)
	gSize = length(P.genes[1].genePool)
	
	pool = populate(poolSize,size)
	
	for i = 1:poolSize
		random = rand(1:size)
		pool.genes[i] = P.genes[random]
	end
	
	f = getFit(pool)
	return f
end

# ╔═╡ 15feb3d0-4b5e-4f45-8e29-18984a885d3e
md"### // Crossover"

# ╔═╡ 22aaf6b4-aa7d-4844-b4a5-745b1edaf9fb
function crossover(g1,g2)
	rate = 0.5
	
	size=length(g1.genePool)
	
	gSize = length(g2.genePool)
	
	offSpring = genes(zeros(Int64,gSize),0)

	for i = 1:size
		if rand() <= rate
			offSpring = genes(g1.genePool,g1.fitness)
		else
			offSpring = genes(g2.genePool,g2.fitness)
		end
	end
	return offSpring
end

# ╔═╡ 299598be-8188-4451-a824-4067dd374c14
md"### // Mutation Probability"

# ╔═╡ 44480dcc-ab4f-44a5-b014-faba689620bf
function mutation(offSpring)
	mRate::Float64 = 0.5
	gSize =length(offSpring.genePool)
	
	for i = 1:gSize
		if rand() < mRate
			offSpring.genePool[i] = rand([1,0])
		end
	end

end

# ╔═╡ 7d9044ff-dfa9-472b-ba39-ff6fd70ffa31
md"### // Evolution Function"

# ╔═╡ fa5f3319-31be-4a7a-b26f-fab51a9a92f0
function evolution(P)
	
	size = length(P.genes)
	 y = population(P.genes)
	
	for i in 1:size
		g1 = selection(P)
        g2 = selection(P)
        oS = crossover(g1, g2)
        y.genes[i] = oS

	end
	
	s2 = length(y.genes)
	for i = 1:s2

	mutation(y.genes[i])
	end
	
    return y
    
end

# ╔═╡ 47cd8b1f-9690-4353-b902-33703ad9d892
md"### // Best Solution Function"

# ╔═╡ 0e4c481d-03ce-41df-b544-9371fc681954
md"# Test GA"

# ╔═╡ 52247fdf-548c-40ae-8c06-381d2359154a
x = populate(50,10)

# ╔═╡ 6997d095-b88a-4465-a67f-54807e1c9dd4
optimalGene = [1,1,1,1,1,1,1,1,1,1]

# ╔═╡ 3559305f-1825-412b-b377-863afad9b820
function best(P)
	gen = 0;
	
while(fitness(getFit(P),optimalGene) < maximum(optimalGene))
  gen += 1
		
  println("Generation: ", gen," Fitness: ",getFit(P).fitness )
  evolved = evolution(P)
	end
	best = getFit(P).genePool
	println("\nBest Solution in Generation ", gen)
	println("\nGene:", best)
end

# ╔═╡ 8d6a968f-5d37-4033-a8b1-1a201563a700
getFit(x)

# ╔═╡ b80e64b1-bf8d-402e-b542-70d2e29d64e2
with_terminal() do
best(x)
end

# ╔═╡ Cell order:
# ╠═ca5a9969-dc3d-4154-a2fd-c0057c5650bf
# ╟─d3e85cf5-c1d9-427f-b75b-db74298ebf30
# ╟─58370141-22fe-4c79-bffc-534bba496ea8
# ╟─b5ef8b65-3ada-4b70-a905-efa2978d4a6c
# ╠═d9300c0c-f329-49ce-a1eb-fd9a52923709
# ╠═ccac7604-7006-41c7-bfea-ccf25ef2cdb5
# ╠═312b5890-b172-4c97-bb96-26e092b9d4b4
# ╟─873e0df3-6b7d-441b-95d6-ee09eb5d325c
# ╠═647f2f4c-55c0-444c-a804-b54b6c96a588
# ╠═9bafd5f1-935a-434e-8a30-3415e0eed5a6
# ╟─59ae2a0a-0c3f-47e7-9abd-bdff524dd018
# ╠═54e2cec7-539a-4e4d-a7d2-901d7598601c
# ╠═d3612443-07d5-41b4-849d-ec6ac1d053e8
# ╟─377a605a-ecd4-4896-a2d3-895a7e1f4230
# ╠═d2efa0ab-63f6-4908-83cf-1e46900eb914
# ╟─15feb3d0-4b5e-4f45-8e29-18984a885d3e
# ╠═22aaf6b4-aa7d-4844-b4a5-745b1edaf9fb
# ╟─299598be-8188-4451-a824-4067dd374c14
# ╠═44480dcc-ab4f-44a5-b014-faba689620bf
# ╟─7d9044ff-dfa9-472b-ba39-ff6fd70ffa31
# ╠═fa5f3319-31be-4a7a-b26f-fab51a9a92f0
# ╟─47cd8b1f-9690-4353-b902-33703ad9d892
# ╠═3559305f-1825-412b-b377-863afad9b820
# ╟─0e4c481d-03ce-41df-b544-9371fc681954
# ╠═52247fdf-548c-40ae-8c06-381d2359154a
# ╠═6997d095-b88a-4465-a67f-54807e1c9dd4
# ╠═8d6a968f-5d37-4033-a8b1-1a201563a700
# ╠═b80e64b1-bf8d-402e-b542-70d2e29d64e2
