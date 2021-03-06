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

# fix for julia release where this function is absent, TODO: remove when we move to julia 0.4+
sub(a::SparseMatrixCSC, I::AbstractVector, ::Colon) = sparse(a[I,:])
sub(a::SubArray, I::AbstractVector, ::Colon) = convert(Array, a[I,:])
sub(a::AbstractMatrix, I::AbstractVector, ::Colon) = a[I,:]
sub(a::AbstractVector, I::AbstractVector, ::Colon) = a[I]
sub(a::AbstractMatrix, i::Int, ::Colon) = a[i,:]
sub(a::AbstractMatrix, ::Colon, ::Colon) = a
sub(a::SparseMatrixCSC, ::Colon, ::Colon) = a
view(a::SparseMatrixCSC, ::Colon, I::Int) = a[:,I]
dot(a::SparseMatrixCSC, b::SparseMatrixCSC) = sum(a.*b)