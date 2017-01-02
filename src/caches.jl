abstract OrdinaryDiffEqCache <: DECache
abstract OrdinaryDiffEqConstantCache <: DECache
abstract OrdinaryDiffEqMutableCache <: DECache
immutable ODEEmptyCache <: OrdinaryDiffEqConstantCache end
immutable ODEChunkCache{CS} <: OrdinaryDiffEqConstantCache end

alg_cache{F}(alg::OrdinaryDiffEqAlgorithm,prob,callback::F) = ODEEmptyCache()

immutable EulerCache{uType,rateType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k::rateType
  fsalfirst::rateType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Euler,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  EulerCache(u,uprev,similar(rate_prototype),similar(rate_prototype))
end

Base.@pure alg_cache(alg::Euler,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = ODEEmptyCache()

immutable MidpointCache{uType,rateType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k::rateType
  kprev::rateType
  du::rateType
  utilde::uType
  fsalfirst::rateType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Midpoint,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  utilde = similar(u)
  k = similar(rate_prototype)
  du = similar(rate_prototype)
  fsalfirst = similar(rate_prototype)
  MidpointCache(u,uprev,kprev,k,du,utilde,fsalfirst)
end

Base.@pure alg_cache(alg::Midpoint,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = ODEEmptyCache()

immutable RK4Cache{uType,rateType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  kprev::rateType
  k₁::rateType
  k₂::rateType
  k₃::rateType
  k₄::rateType
  k::rateType
  tmp::uType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::RK4,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  k₁ = similar(rate_prototype)
  k₂ = similar(rate_prototype)
  k₃ = similar(rate_prototype)
  k₄ = similar(rate_prototype)
  k = similar(rate_prototype)
  tmp = similar(u)
  RK4Cache(u,uprev,kprev,k₁,k₂,k₃,k₄,k,tmp)
end

Base.@pure alg_cache(alg::RK4,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = ODEEmptyCache()

immutable BS3Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  kprev::rateType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  utilde::uType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::BS3,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = BS3ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype)
  k2 = similar(rate_prototype)
  k3 = similar(rate_prototype)
  k4 = similar(rate_prototype)
  utilde = similar(u)
  atmp = similar(u,uEltypeNoUnits)
  tmp = similar(u)
  BS3Cache(u,uprev,kprev,k1,k2,k3,k4,utilde,tmp,atmp,tab)
end

Base.@pure alg_cache(alg::BS3,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = BS3ConstantCache(uEltypeNoUnits)

immutable BS5Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  utilde::uType
  uhat::uType
  tmp::uType
  atmp::uEltypeNoUnits
  atmptilde::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::BS5,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = BS5ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype)
  k2 = similar(rate_prototype)
  k3 = similar(rate_prototype)
  k4 = similar(rate_prototype)
  k5 = similar(rate_prototype)
  k6 = similar(rate_prototype)
  k7 = similar(rate_prototype)
  k8 = similar(rate_prototype)
  utilde = similar(u); uhat = similar(u)
  atmp = similar(u,uEltypeNoUnits)
  tmp = similar(u)
  atmptilde = similar(u,uEltypeNoUnits)
  BS5Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,utilde,uhat,tmp,atmp,atmptilde,tab)
end

Base.@pure alg_cache(alg::BS5,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = BS5ConstantCache(uEltypeNoUnits)

immutable Tsit5Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  utilde::uType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Tsit5,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = Tsit5ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype)
  k2 = similar(rate_prototype)
  k3 = similar(rate_prototype)
  k4 = similar(rate_prototype)
  k5 = similar(rate_prototype)
  k6 = similar(rate_prototype)
  k7 = similar(rate_prototype)
  utilde = similar(u)
  atmp = similar(u,uEltypeNoUnits)
  tmp = similar(u)
  atmptilde = similar(u,uEltypeNoUnits)
  Tsit5Cache(u,k1,k2,k3,k4,k5,k6,k7,utilde,tmp,atmp,tab)
end

Base.@pure alg_cache(alg::Tsit5,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = Tsit5ConstantCache(uEltypeNoUnits)

immutable DP5Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  dense_tmp3::rateType
  dense_tmp4::rateType
  update::rateType
  bspl::rateType
  utilde::uType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::DP5,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  k1 = similar(rate_prototype)
  k2 = similar(rate_prototype)
  k3 = similar(rate_prototype)
  k4 = similar(rate_prototype)
  k5 = similar(rate_prototype)
  k6 = similar(rate_prototype)
  k7 = similar(rate_prototype)
  dense_tmp3 = similar(rate_prototype)
  dense_tmp4 = similar(rate_prototype)
  update = similar(rate_prototype)
  bspl = similar(rate_prototype)
  utilde = similar(u)
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits)
  tab = DP5ConstantCache(uEltypeNoUnits)
  DP5Cache(u,k1,k2,k3,k4,k5,k6,k7,dense_tmp3,dense_tmp4,update,bspl,utilde,tmp,atmp,tab)
end

Base.@pure alg_cache(alg::DP5,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = DP5ConstantCache(uEltypeNoUnits)

Base.@pure alg_cache(alg::DP5Threaded,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = alg_cache(DP5(),u,rate_prototype,uEltypeNoUnits,uprev,kprev)

immutable Vern6Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  utilde::uType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Vern6,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = Vern6ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype)
  k2 = similar(rate_prototype); k3 = similar(rate_prototype); k4 = similar(rate_prototype);
  k5 = similar(rate_prototype); k6 = similar(rate_prototype); k7 = similar(rate_prototype);
  k8 = similar(rate_prototype); k9 = similar(rate_prototype);
  utilde = similar(u); tmp = similar(u); atmp = similar(u,uEltypeNoUnits);
  Vern6Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,k9,utilde,tmp,atmp,tab)
end

Base.@pure alg_cache(alg::Vern6,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = Vern6ConstantCache(uEltypeNoUnits)

immutable Vern7Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  utilde::uType
  update::uType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Vern7,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = Vern7ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype); k2 = similar(rate_prototype); k3 = similar(rate_prototype); k4 = similar(rate_prototype);
  k5 = similar(rate_prototype); k6 = similar(rate_prototype); k7 = similar(rate_prototype); k8 = similar(rate_prototype);
  k9 = similar(rate_prototype); k10 = similar(rate_prototype); utilde = similar(u); update = similar(u)
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits)
  Vern7Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,utilde,update,tmp,atmp,tab)
end

Base.@pure alg_cache(alg::Vern7,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = Vern7ConstantCache(uEltypeNoUnits)


immutable Vern8Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  k11::rateType
  k12::rateType
  k13::rateType
  utilde::uType
  update::uType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Vern8,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = Vern8ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype); k2 = similar(rate_prototype); k3 = similar(rate_prototype);
  k4 = similar(rate_prototype);
  k5 = similar(rate_prototype); k6 = similar(rate_prototype); k7 = similar(rate_prototype);
  k8 = similar(rate_prototype); tmp = similar(u)
  k9 = similar(rate_prototype); k10 = similar(rate_prototype); k11 = similar(rate_prototype);
  k12 = similar(rate_prototype); k13 = similar(rate_prototype)
  utilde = similar(u); update = similar(u);
  atmp = similar(u,uEltypeNoUnits)
  Vern8Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,utilde,update,tmp,atmp,tab)
end

Base.@pure alg_cache(alg::Vern8,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = Vern8ConstantCache(uEltypeNoUnits)

immutable Vern9Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  k11::rateType
  k12::rateType
  k13::rateType
  k14::rateType
  k15::rateType
  k16::rateType
  utilde::uType
  update::uType
  tmp::uType
  atmp::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Vern9,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = Vern9ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype); k2 = similar(rate_prototype);k3 = similar(rate_prototype);
  k4 = similar(rate_prototype);
  k5 = similar(rate_prototype); k6 = similar(rate_prototype);k7 = similar(rate_prototype);
  k8 = similar(rate_prototype);
  k9 = similar(rate_prototype); k10 = similar(rate_prototype); k11 = similar(rate_prototype);
  k12 = similar(rate_prototype); update = similar(u)
  k13 = similar(rate_prototype); k14 = similar(rate_prototype); k15 = similar(rate_prototype);
  k16 =similar(rate_prototype);
  utilde = similar(u); tmp = similar(u); atmp = similar(u,uEltypeNoUnits);
  Vern9Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,utilde,update,tmp,atmp,tab)
end

Base.@pure alg_cache(alg::Vern9,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = Vern9ConstantCache(uEltypeNoUnits)

immutable TanYam7Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  kprev::rateType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  utilde::uType
  tmp::uType
  atmp::uEltypeNoUnits
  k::rateType
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::TanYam7,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = TanYam7ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype); k2 = similar(rate_prototype) ; k3 = similar(rate_prototype); k4 = similar(rate_prototype)
  k5 = similar(rate_prototype); k6 = similar(rate_prototype) ; k7 = similar(rate_prototype); k8 = similar(rate_prototype)
  k9 = similar(rate_prototype); k10= similar(rate_prototype) ;
  utilde = similar(u); tmp = similar(u); atmp = similar(u,uEltypeNoUnits); k = similar(rate_prototype)
  TanYam7Cache(u,uprev,kprev,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,utilde,tmp,atmp,k,tab)
end

Base.@pure alg_cache(alg::TanYam7,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = TanYam7ConstantCache(uEltypeNoUnits)


immutable DP8Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  k11::rateType
  k12::rateType
  k13::rateType
  k14::rateType
  k15::rateType
  k16::rateType
  kupdate::rateType
  update::uType
  udiff::rateType
  bspl::rateType
  dense_tmp3::rateType
  dense_tmp4::rateType
  dense_tmp5::rateType
  dense_tmp6::rateType
  dense_tmp7::rateType
  utilde::uType
  tmp::uType
  atmp::uEltypeNoUnits
  atmp2::uEltypeNoUnits
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::DP8,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  k1 = similar(rate_prototype); k2  = similar(rate_prototype); k3  = similar(rate_prototype);  k4 = similar(rate_prototype)
  k5 = similar(rate_prototype); k6  = similar(rate_prototype); k7  = similar(rate_prototype);  k8 = similar(rate_prototype)
  k9 = similar(rate_prototype); k10 = similar(rate_prototype); k11 = similar(rate_prototype); k12 = similar(rate_prototype)
  kupdate = similar(rate_prototype); utilde = similar(u);
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits); atmp2 = similar(u,uEltypeNoUnits); update = similar(u)
  k13 = similar(rate_prototype)
  k14 = similar(rate_prototype)
  k15 = similar(rate_prototype)
  k16 = similar(rate_prototype)
  udiff = similar(rate_prototype)
  bspl = similar(rate_prototype)
  # dense_tmp1 = udiff
  # dense_tmp2 = bspl
  dense_tmp3 = similar(rate_prototype)
  dense_tmp4 = similar(rate_prototype)
  dense_tmp5 = similar(rate_prototype)
  dense_tmp6 = similar(rate_prototype)
  dense_tmp7 = similar(rate_prototype)
  tab = DP8ConstantCache(uEltypeNoUnits)
  DP8Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,kupdate,
           update,udiff,bspl,dense_tmp3,dense_tmp4,dense_tmp5,dense_tmp6,dense_tmp7,
           utilde,tmp,atmp,atmp2,tab)
end

Base.@pure alg_cache(alg::DP8,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = DP8ConstantCache(uEltypeNoUnits)

immutable TsitPap8Cache{uType,rateType,uEltypeNoUnits,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  kprev::rateType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  k11::rateType
  k12::rateType
  k13::rateType
  utilde::uType
  update::uType
  tmp::uType
  atmp::uEltypeNoUnits
  k::rateType
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::TsitPap8,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = TsitPap8ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype); k2 = similar(rate_prototype); k3 = similar(rate_prototype); k4 = similar(rate_prototype)
  k5 = similar(rate_prototype); k6 = similar(rate_prototype); k7 = similar(rate_prototype); k8 = similar(rate_prototype)
  k9 = similar(rate_prototype); k10 = similar(rate_prototype); k11 = similar(rate_prototype); k12 = similar(rate_prototype)
  k13 = similar(rate_prototype); update = similar(u); utilde = similar(u); k = similar(rate_prototype)
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits);
  TsitPap8Cache(u,uprev,kprev,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,utilde,update,tmp,atmp,k,tab)
end

Base.@pure alg_cache(alg::TsitPap8,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = TsitPap8ConstantCache(uEltypeNoUnits)

immutable ExplicitRKCache{uType,rateType,uEltypeNoUnits,ksEltype,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  tmp::uType
  utilde::rateType
  uEEst::rateType
  atmp::uEltypeNoUnits
  uprev::uType
  kprev::ksEltype
  kk::Vector{ksEltype}
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::ExplicitRK,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  kk = Vector{typeof(rate_prototype)}(0)
  for i = 1:alg.tableau.stages
    push!(kk,similar(rate_prototype))
  end
  utilde = similar(rate_prototype)
  tmp = similar(u)
  atmp = similar(u,uEltypeNoUnits)
  uEEst = similar(rate_prototype)
  tab = ExplicitRKConstantCache(alg.tableau,rate_prototype)
  ExplicitRKCache(u,tmp,utilde,uEEst,atmp,uprev,kprev,kk,tab)
end

immutable ExplicitRKConstantCache{MType,VType,KType} <: OrdinaryDiffEqConstantCache
  A::MType
  c::VType
  α::VType
  αEEst::VType
  stages::Int
  kk::KType
end

function ExplicitRKConstantCache(tableau,rate_prototype)
  @unpack A,c,α,αEEst,stages = tableau
  A = A' # Transpose A to column major looping
  kk = Array{typeof(rate_prototype)}(stages) # Not ks since that's for integrator.opts.dense
  ExplicitRKConstantCache(A,c,α,αEEst,stages,kk)
end

Base.@pure alg_cache(alg::ExplicitRK,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = ExplicitRKConstantCache(alg.tableau,rate_prototype)

immutable Feagin10Cache{uType,uEltypeNoUnits,rateType,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  k11::rateType
  k12::rateType
  k13::rateType
  k14::rateType
  k15::rateType
  k16::rateType
  k17::rateType
  tmp::uType
  atmp::uEltypeNoUnits
  uprev::uType
  kprev::rateType
  k::rateType
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Feagin10,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = Feagin10ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype); k2 = similar(rate_prototype); k3 = similar(rate_prototype); k4 = similar(rate_prototype); k5 = similar(rate_prototype)
  k6 = similar(rate_prototype); k7 = similar(rate_prototype); k8 = similar(rate_prototype); k9 = similar(rate_prototype); k10 = similar(rate_prototype)
  k11 = similar(rate_prototype); k12 = similar(rate_prototype); k13 = similar(rate_prototype); k14 = similar(rate_prototype)
  k15 = similar(rate_prototype); k16 = similar(rate_prototype); k17 = similar(rate_prototype)
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits); k = similar(rate_prototype)

  Feagin10Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,tmp,atmp,uprev,kprev,k,tab)
end

Base.@pure alg_cache(alg::Feagin10,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = Feagin10ConstantCache(uEltypeNoUnits)

immutable Feagin12Cache{uType,uEltypeNoUnits,rateType,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  k11::rateType
  k12::rateType
  k13::rateType
  k14::rateType
  k15::rateType
  k16::rateType
  k17::rateType
  k18::rateType
  k19::rateType
  k20::rateType
  k21::rateType
  k22::rateType
  k23::rateType
  k24::rateType
  k25::rateType
  tmp::uType
  atmp::uEltypeNoUnits
  uprev::uType
  kprev::rateType
  k::rateType
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Feagin12,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = Feagin12ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype); k2 = similar(rate_prototype); k3 = similar(rate_prototype); k4 = similar(rate_prototype); k5 = similar(rate_prototype)
  k6 = similar(rate_prototype); k7 = similar(rate_prototype); k8 = similar(rate_prototype); k9 = similar(rate_prototype); k10 = similar(rate_prototype)
  k11 = similar(rate_prototype); k12 = similar(rate_prototype); k13 = similar(rate_prototype); k14 = similar(rate_prototype)
  k15 = similar(rate_prototype); k16 = similar(rate_prototype); k17 = similar(rate_prototype); k18 = similar(rate_prototype)
  k19 = similar(rate_prototype); k20 = similar(rate_prototype); k21 = similar(rate_prototype); k22 = similar(rate_prototype)
  k23 = similar(rate_prototype); k24 = similar(rate_prototype); k25 = similar(rate_prototype)
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits); k = similar(rate_prototype)

  Feagin12Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18,k19,k20,k21,k22,k23,k24,k25,tmp,atmp,uprev,kprev,k,tab)
end

Base.@pure alg_cache(alg::Feagin12,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = Feagin12ConstantCache(uEltypeNoUnits)


immutable Feagin14Cache{uType,uEltypeNoUnits,rateType,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k1::rateType
  k2::rateType
  k3::rateType
  k4::rateType
  k5::rateType
  k6::rateType
  k7::rateType
  k8::rateType
  k9::rateType
  k10::rateType
  k11::rateType
  k12::rateType
  k13::rateType
  k14::rateType
  k15::rateType
  k16::rateType
  k17::rateType
  k18::rateType
  k19::rateType
  k20::rateType
  k21::rateType
  k22::rateType
  k23::rateType
  k24::rateType
  k25::rateType
  k26::rateType
  k27::rateType
  k28::rateType
  k29::rateType
  k30::rateType
  k31::rateType
  k32::rateType
  k33::rateType
  k34::rateType
  k35::rateType
  tmp::uType
  atmp::uEltypeNoUnits
  uprev::uType
  kprev::rateType
  k::rateType
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Feagin14,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  tab = Feagin14ConstantCache(uEltypeNoUnits)
  k1 = similar(rate_prototype); k2 = similar(rate_prototype); k3 = similar(rate_prototype); k4 = similar(rate_prototype); k5 = similar(rate_prototype)
  k6 = similar(rate_prototype); k7 = similar(rate_prototype); k8 = similar(rate_prototype); k9 = similar(rate_prototype); k10 = similar(rate_prototype)
  k11 = similar(rate_prototype); k12 = similar(rate_prototype); k13 = similar(rate_prototype); k14 = similar(rate_prototype)
  k15 = similar(rate_prototype); k16 = similar(rate_prototype); k17 = similar(rate_prototype); k18 = similar(rate_prototype)
  k19 = similar(rate_prototype); k20 = similar(rate_prototype); k21 = similar(rate_prototype); k22 = similar(rate_prototype)
  k23 = similar(rate_prototype); k24 = similar(rate_prototype); k25 = similar(rate_prototype)
  k26 = similar(rate_prototype); k27 = similar(rate_prototype); k28 = similar(rate_prototype)
  k29 = similar(rate_prototype); k30 = similar(rate_prototype); k31 = similar(rate_prototype); k32 = similar(rate_prototype)
  k33 = similar(rate_prototype); k34 = similar(rate_prototype); k35 = similar(rate_prototype)
  tmp = similar(u); atmp = similar(u,uEltypeNoUnits); k = similar(rate_prototype)

  Feagin14Cache(u,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,
                k17,k18,k19,k20,k21,k22,k23,k24,k25,k26,k27,k28,k29,k30,
                k31,k32,k33,k34,k35,tmp,atmp,uprev,kprev,k,tab)
end

Base.@pure alg_cache(alg::Feagin14,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = Feagin14ConstantCache(uEltypeNoUnits)


immutable LowOrderRosenbrockCache{uType,rateType,vecuType,JType,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  k₁::rateType
  k₂::rateType
  k₃::rateType
  du1::rateType
  du2::rateType
  f₁::rateType
  vectmp::vecuType
  vectmp2::vecuType
  vectmp3::vecuType
  fsalfirst::rateType
  fsallast::rateType
  dT::uType
  J::JType
  W::JType
  tmp2::uType
  tab::TabType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Rosenbrock23,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  k₁ = similar(rate_prototype)
  k₂ = similar(rate_prototype)
  k₃ = similar(rate_prototype)
  du1 = similar(rate_prototype)
  du2 = similar(rate_prototype)
  # f₀ = similar(u) fsalfirst
  f₁ = similar(rate_prototype)
  vectmp = similar(vec(u))
  vectmp2 = similar(vec(u))
  vectmp3 = similar(vec(u))
  fsalfirst = similar(rate_prototype)
  fsallast = similar(rate_prototype)
  dT = similar(u)
  J = zeros(uEltypeNoUnits,length(u),length(u)) # uEltype?
  W = similar(J); tmp2 = similar(u)
  tab = LowOrderRosenbrockConstantCache(uEltypeNoUnits)
  LowOrderRosenbrockCache(u,k₁,k₂,k₃,du1,du2,f₁,vectmp,vectmp2,vectmp3,fsalfirst,fsallast,dT,J,W,tmp2,tab)
end

alg_cache{uType<:AbstractArray}(alg::Rosenbrock32,u::uType,
                                rate_prototype,uEltypeNoUnits,
                                uprev,kprev) =
                                alg_cache(Rosenbrock23(),u,rate_prototype,uEltypeNoUnits,uprev,kprev)

Base.@pure alg_cache(alg::Rosenbrock23,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = LowOrderRosenbrockConstantCache(uEltypeNoUnits)
Base.@pure alg_cache(alg::Rosenbrock32,u,rate_prototype,uEltypeNoUnits,uprev,kprev) = LowOrderRosenbrockConstantCache(uEltypeNoUnits)

immutable ImplicitEulerCache{uType,DiffCacheType,rateType,CS} <: OrdinaryDiffEqMutableCache
  u::uType
  dual_cache::DiffCacheType
  u_old::uType
  k::rateType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::ImplicitEuler,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  u_old = similar(u); k = similar(rate_prototype)
  if get_chunksize(alg) != 0
    dual_cache = DiffCache(u,alg)
    ImplicitEulerCache{typeof(u),typeof(dual_cache),typeof(k),get_chunksize(alg)}(u,dual_cache,u_old,k)
  else
    dual_cache = DiffCache(u)
    ImplicitEulerCache{typeof(u),typeof(dual_cache),typeof(k),ForwardDiff.pickchunksize(length(u))}(u,dual_cache,u_old,k)
  end
end

Base.@pure function alg_cache{uType}(alg::ImplicitEuler,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  if get_chunksize(alg) != 0
    return ODEChunkCache{get_chunksize(alg)}()
  else
    return ODEChunkCache{ForwardDiff.pickchunksize(length(u))}()
  end
end

immutable TrapezoidCache{uType,DiffCacheType,rateType,CS} <: OrdinaryDiffEqMutableCache
  u::uType
  dual_cache::DiffCacheType
  dual_cache2::DiffCacheType
  u_old::uType
  k::rateType
end

Base.@pure function alg_cache{uType<:AbstractArray}(alg::Trapezoid,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  u_old = similar(u);k = similar(rate_prototype)
  if get_chunksize(alg) != 0
    dual_cache = DiffCache(u,alg)
    dual_cache2 = DiffCache(u,alg)
    TrapezoidCache{typeof(u),typeof(dual_cache),typeof(k),get_chunksize(alg)}(u,dual_cache,dual_cache2,u_old,k)
  else
    dual_cache = DiffCache(u)
    dual_cache2 = DiffCache(u)
    TrapezoidCache{typeof(u),typeof(dual_cache),typeof(k),ForwardDiff.pickchunksize(length(u))}(u,dual_cache,dual_cache2,u_old,k)
  end
end

Base.@pure function alg_cache{uType}(alg::Trapezoid,u::uType,rate_prototype,uEltypeNoUnits,uprev,kprev)
  if get_chunksize(alg) != 0
    return ODEChunkCache{get_chunksize(alg)}()
  else
    return ODEChunkCache{ForwardDiff.pickchunksize(length(u))}()
  end
end

get_chunksize(cache::DECache) = error("This cache does not have a chunksize.")
Base.@pure get_chunksize{uType,DiffCacheType,rateType,CS}(cache::ImplicitEulerCache{uType,DiffCacheType,rateType,CS}) = CS
Base.@pure get_chunksize{uType,DiffCacheType,rateType,CS}(cache::TrapezoidCache{uType,DiffCacheType,rateType,CS}) = CS
Base.@pure get_chunksize{CS}(cache::ODEChunkCache{CS}) = CS
