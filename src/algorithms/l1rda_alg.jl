# 
# Software Lab for Advanced Machine Learning with Stochastic Algorithms
# Copyright (c) 2015 Vilen Jumutc, KU Leuven, ESAT-STADIUS 
# License & help @ https://github.com/jumutc/SALSA.jl
# Documentation @ http://salsajl.readthedocs.org
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

function l1rda_alg(dfunc::Function, X, Y, λ::Float64, γ::Float64, ρ::Float64, 
                   k::Int, max_iter::Int, tolerance::Float64, online_pass=0, train_idx=[])

    # Internal function for a simple l1-RDA routine
    #
    # Copyright (c) 2015, KU Leuven-ESAT-STADIUS, License & help @
    # http://www.esat.kuleuven.be/stadius/ADB/jumutc/softwareSALSA.php

    N = size(X,1)
    d = size(X,2) + 1
    check = ~issparse(X) 
    
    if check
        g = zeros(d,1)
        w = rand(d,1)/100
        sub_arr = (I) -> [sub(X,I,:) ones(k,1)]'
    else 
        g = spzeros(d,1)
        total = length(X.nzval)
        w = sprand(d,1,total/(N*d))/100
        X = [X'; sparse(ones(1,N))]
        sub_arr = (I) -> X[:,I]
    end

    space, N = fix_space(train_idx,N)
    smpl = fix_sampling(online_pass,N)
    max_iter = fix_iter(online_pass,N,max_iter)

    for t=1:max_iter 
        idx = space[smpl(t,k)]
        w_prev = w

        yt = Y[idx]
        At = sub_arr(idx)
        
        # calculate dual average: gradient
        g = ((t-1)/t).*g + (1/(t)).*dfunc(At,yt,w)
        λ_rda = λ+(ρ*γ)/sqrt(t)
        
        # find a close form solution
        if check
            w = -(sqrt(t)/γ).*(g - λ_rda.*sign(g))
            w[abs(g).<=λ_rda] = 0
        else
            # do not perform sparse(...) and filter and map over SparceMatrixCSC
            # because Garbage Collection performs realy badly in the tight loops
            gs = SparseMatrixCSC(d,1,g.colptr,g.rowval,sign(g.nzval))
            w = -(sqrt(t)/γ).*(g - λ_rda.*gs); ind = abs(g.nzval) .> λ_rda
            w = reduce_sparsevec(w,find(ind)) 
        end

        # check the stopping criterion w.r.t. Tolerance, check, online_pass
        if online_pass == 0 && check && vecnorm(w - w_prev) < tolerance
            break
        end
    end

    w[1:end-1,:], w[end,:]
end