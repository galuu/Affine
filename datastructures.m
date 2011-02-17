(* 

   finiteWeight[dimension]=dimension_Integer
   finiteWeight[standardBase]=List[x__Integer]
   
   affineWeight[finitePart]=x_finiteWeight
   affineWeight[grade]=grade_Integer
   affineWeight[level]=level_Integer
   

   Finite Weight: finiteWeight[dimension][<id>][dimension]
                                              [standardBase]
   Affine Weight: affineWeight[dimension][<id>][finitePart]
   Affine Weight: affineWeight[dimension][<id>][level]
   Affine Weight: affineWeight[dimension][<id>][grade]
   
   *)

clear[finiteWeight,affineWeight,dimension,standardBase,simpleRootBase,level,grade];

clear[Expect];

Expect[ description_, val_, expr_ ] := 
If[
    val != expr,
    Throw[
        StringJoin[ "GOT UNEXPECTED VALUE ", ToString[expr], 
        " INSTEAD OF ", ToString[val] ]
        , "assertion exception"
    ]
]


makeFiniteWeight[{coordinates__?NumberQ}]:=Module[{uniq=finiteWeight[Unique[]]},
				      uniq[dimension]=Length[{coordinates}];
				      uniq[standardBase]={coordinates};
				      uniq]

Expect["Dimension equals to length",3,makeFiniteWeight[{1,2,3}][dimension]]

finiteWeight/:Print[x_finiteWeight]:=Print[x,x[standardBase]]


(*

Print[makeFiniteWeight[{1,2,3}]]

finiteWeight[$114]{1, 2, 3}

*)

finiteWeight/:x_finiteWeight . y_finiteWeight/;x[dimension]==y[dimension]:=x[standardBase].y[standardBase]

Expect["Scalar product for vectors from weigth space of finite-dimensional Lie algebras",10,makeFiniteWeight[{1,2,3}].makeFiniteWeight[{3,2,1}]]


Expect["Scalar product for vectors from different spaces are left unevaluated",True,
       MatchQ[makeFiniteWeight[{1,2,3}].makeFiniteWeight[{3,2,1,2}],finiteWeight[x_] . finiteWeight[y_]]]

finiteWeight/:x_finiteWeight+y_finiteWeight/;x[dimension]==y[dimension]:=makeFiniteWeight[x[standardBase]+y[standardBase]]

Expect["Plus for finite-dimensional weights",{2,4,6},(makeFiniteWeight[{1,2,3}]+makeFiniteWeight[{1,2,3}])[standardBase]]

Expect["Plus product for vectors from different spaces are left unevaluated",True,
       MatchQ[makeFiniteWeight[{1,2,3}]+makeFiniteWeight[{3,2,1,2}],finiteWeight[x_] + finiteWeight[y_]]]

finiteWeight/:finiteWeight[x_]==finiteWeight[y_]:=finiteWeight[x][standardBase]==finiteWeight[y][standardBase]

Expect["Equal for finite weights compares standard base representations", False,makeFiniteWeight[{1,2,3}]==makeFiniteWeight[{1,3,2}]]

Expect["Equal for finite weights compares standard base representations", True,makeFiniteWeight[{1,2,3}]==makeFiniteWeight[{1,2,3}]]

Expect["Equal for finite weights compares standard base representations", False,makeFiniteWeight[{1,2,3}]==makeFiniteWeight[{1,2,3,4}]]

finiteWeight/:x_?NumberQ*y_finiteWeight:=makeFiniteWeight[x*y[standardBase]]

Expect["Multiplication by scalar", True,makeFiniteWeight[{1,2,3}]*2==makeFiniteWeight[{2,4,6}]]

Expect["Multiplication by scalar", True,2*makeFiniteWeight[{1,2,3}]==makeFiniteWeight[{2,4,6}]]

makeAffineWeight[fw:finiteWeight[u_Symbol],lev_?NumberQ,gr_?NumberQ]:=Module[{res=affineWeight[Unique[]]},
											res[dimension]=fw[dimension];
											res[level]=lev;
											res[grade]=gr;
											res[finitePart]=fw;
											res]

Expect["Affine weight has the same real dimension as the finite-dimensional part, since we hold level and grade separetely",
       True,makeAffineWeight[makeFiniteWeight[{1,2,3,4,5}],1,2][dimension]==Length[{1,2,3,4,5}]]

makeAffineWeight[{fp__?NumberQ},lev_?NumberQ,gr_?NumberQ]:=makeAffineWeight[makeFiniteWeight[{fp}],lev,gr]

Expect["Shortened constructor",
       True,makeAffineWeight[{1,2,3,4,5},1,2][dimension]==Length[{1,2,3,4,5}]]

affineWeight/:x_affineWeight==y_affineWeight:=And[x[finitePart]==y[finitePart],
						      x[level]==y[level],
						      x[grade]==y[grade]]

Expect["Equal for affine weights compares finite parts, levels and grades", True,makeAffineWeight[makeFiniteWeight[{1,2,3}],1,2]==makeAffineWeight[makeFiniteWeight[{1,2,3}],1,2]]

Expect["Equal for affine weights compares finite parts, levels and grades", False,makeAffineWeight[makeFiniteWeight[{1,2,3}],2,1]==makeAffineWeight[makeFiniteWeight[{1,2,3}],1,2]]

affineWeight/:x_affineWeight+y_affineWeight/;x[dimension]==y[dimension]:=
    makeAffineWeight[x[finitePart]+y[finitePart],
		     x[level]+y[level],
		     x[grade]+y[grade]]


Expect["Plus for affine weights",{2,4,6},(makeAffineWeight[makeFiniteWeight[{1,2,3}],1,2]+ makeAffineWeight[makeFiniteWeight[{1,2,3}],3,1])[finitePart][standardBase]]

Expect["Plus for affine weights",4,(makeAffineWeight[makeFiniteWeight[{1,2,3}],1,2]+ makeAffineWeight[makeFiniteWeight[{1,2,3}],3,1])[level]]

Expect["We compare dimensions of vectors before sum calculation, the expression is left unevaluated in case of dimension mismatch ",
       True,MatchQ[makeAffineWeight[makeFiniteWeight[{1,2}],1,2] + makeAffineWeight[ makeFiniteWeight[{3,2,1}],2,1], affineWeight[x_] + affineWeight[y_]]]

affineWeight/:x_affineWeight.y_affineWeight/;x[dimension]==y[dimension]:= 
    x[finitePart].y[finitePart] + 
    x[level]* y[grade] + 
    x[grade]* y[level]

Expect["Scalar product for vectors from weigth space of affine Lie algebras",20,
       makeAffineWeight[makeFiniteWeight[{1,2,3}],1,2]. 
       makeAffineWeight[makeFiniteWeight[{3,2,1}],3,4]]

Expect["We compare dimensions of vectors before product calculation, the expression is left unevaluated in case of dimension mismatch ",
       True,MatchQ[makeAffineWeight[makeFiniteWeight[{1,2}],1,2]. makeAffineWeight[ makeFiniteWeight[{3,2,1}],2,1], affineWeight[x_] . affineWeight[y_]]]


affineWeight/:x_?NumberQ*y_affineWeight:=makeAffineWeight[x*y[finitePart],x*y[level],x*y[grade]]

Expect["Multiplication by scalar", True,makeAffineWeight[makeFiniteWeight[{1,2,3}],1,2]*2==makeAffineWeight[makeFiniteWeight[{2,4,6}],2,4]]


ExpandNCM[(h : NonCommutativeMultiply)[a___, b_Plus, c___]] :=  Distribute[h[a, b, c], Plus, h, Plus, ExpandNCM[h[##]] &];
ExpandNCM[a_] := ExpandAll[a];
ExpandNCM[(a + b) ** (a + b) ** (a + b)];
keys = DownValues[#,Sort->False][[All,1,1,1]]&;

makeFiniteWeight/@Table[If[i==j,1,If[i==j-1,-1,0]],{i,1,3},{j,1,3+1}]

makeRootSystem[{roots__finiteWeight}]:=Module[{rs=finiteRootSystem[Unique[]]},
					      rs[simpleRoots]={roots};
					      rs[rank]=Length[{roots}];
					      rs]

makeRootSystem[{roots__List}]:=Module[{rs=finiteRootSystem[Unique[]]},
					      rs[simpleRoots]=makeFiniteWeight/@{roots};
					      rs[rank]=Length[{roots}];
					      rs]

makeSimpleRootSystem[A,r_Integer]:=makeRootSystem[makeFiniteWeight /@ Table[If[i==j,1,If[i==j-1,-1,0]],{i,1,r},{j,1,r+1}]];
makeSimpleRootSystem[B,rank_Integer]:=makeRootSystem[Append[Table[If[i==j,1,If[i==j-1,-1,0]],{i,1,rank-1},{j,1,rank}],Append[Table[0,{rank-1}],1]]];
makeSimpleRootSystem[C,rank_Integer]:=makeRootSystem[Append[Table[If[i==j,1,If[i==j-1,-1,0]],{i,1,rank-1},{j,1,rank}],Append[Table[0,{rank-1}],2]]];
makeSimpleRootSystem[D,rank_Integer]:=makeRootSystem[Append[Table[If[i==j,1,If[i==j-1,-1,0]],{i,1,rank-1},{j,1,rank}],Append[Append[Table[0,{rank-2}],1],1]]];

Expect["B2:",True,makeSimpleRootSystem[B,2][simpleRoots][[1]]==makeFiniteWeight[{1,-1}]]

Expect["B2: rank",2,makeSimpleRootSystem[B,2][rank]]

reflection[x_finiteWeight]:=Function[y, y-2*(x.y)/(x.x)*x];
reflection[x_affineWeight]:=Function[y, y-2*(x.y)/(x.x)*x];

Expect["Reflection for finite weights", True,reflection[makeFiniteWeight[{1,0}]][makeFiniteWeight[{1,1}]]==makeFiniteWeight[{-1,1}]]

coroot[x_standardBase]:=2*x/(x.x);
cartanMatrix[{x__standardBase}]:=Transpose[Outer[Dot,{x},coroot/@{x}]];
clear[weylGroupElement];
revApply[x_,f_]:=f[x];
weylGroupElement[x__Integer][{y__standardBase}]:=Function[z,Fold[revApply,z,reflection /@ Part[{y},{x}]]];
fundamentalWeights[{simpleRoots__standardBase}]:=Plus@@(Inverse[cartanMatrix[{simpleRoots}]]*{simpleRoots});
rho[{simpleRoots__standardBase}]:=Plus@@fundamentalWeights[{simpleRoots}];
toFundamentalChamber[{simpleRoots__standardBase}][vec_standardBase]:=
    First[NestWhile[Function[v,
		       reflection[Scan[If[#.v<0,Return[#]]&,{simpleRoots}]][v]],
	      vec,
	      Head[#]=!=reflection[Null]&]];
orbit[{simpleRoots__standardBase}][{weights__standardBase}]:=
    NestWhileList[
	Function[x,
		 Union[Flatten[Map[Function[y,
					    Map[reflection[#][y]&,Cases[{simpleRoots},z_ /; z.y>0]]],x]]]],
	{weights},
	#=!={}&];
orbit[{simpleRoots__standardBase}][weight_standardBase]:=orbit[{simpleRoots}][{toFundamentalChamber[{simpleRoots}][weight]}];
positiveRoots[{simpleRoots__standardBase}]:=Map[-#&,Flatten[orbit[{simpleRoots}][Map[-#&,{simpleRoots}]]]];
weightSystem[{simpleRoots__standardBase}][higestWeight_standardBase]:=Module[{minusPosRoots=-positiveRoots[{simpleRoots}]},
									     NestWhileList[Function[x,Complement[
										 Cases[Flatten[Outer[Plus,minusPosRoots,x]],y_/;And@@(#.y>=0&/@{simpleRoots})]
										 ,x]],{higestWeight},#=!={}&]];
freudenthalMultiplicities[{simpleRoots__standardBase}][highestWeight_standardBase]:=
    Module[{rh=rho[{simpleRoots}],weights,mults,c,insideQ,
	    posroots=positiveRoots[{simpleRoots}],
	    toFC=toFundamentalChamber[{simpleRoots}]},
	   weights=SortBy[ Rest[Flatten[weightSystem[{simpleRoots}][highestWeight]]], -#.rh&];
	   c:=(#+rh).(#+rh)&;
	   mults[highestWeight]=1;
	   insideQ:=IntegerQ[mults[toFC[#]]]&;
	   Scan[Function[v,
			 mults[v]=
			 2/(c[highestWeight]-c[v])*
			 Plus@@
			     Map[Function[r,
					  Plus@@Map[mults[toFC[#[[1]]]]*#[[2]]&,
						    Rest[NestWhileList[({#[[1]]+r,#[[2]]+r.r})&,
								       {v,v.r},
								       insideQ[#[[1]]+r]&]]]]
				 ,posroots]],
		weights];
	   mults];
orbitWithEps[{simpleRoots__standardBase}][weight_standardBase]:=Flatten[Most[MapIndexed[Function[{x,i},Map[{#,(-1)^(i[[1]]+1)}&,x]],orbit[{simpleRoots}][weight]]],1];
racahMultiplicities[{simpleRoots__standardBase}][highestWeight_standardBase]:=
    Module[{rh=rho[{simpleRoots}],weights,mults,c,insideQ,
	    fan,
	    toFC=toFundamentalChamber[{simpleRoots}]},
	   fan=Map[{rh-#[[1]],#[[2]]}&,Rest[orbitWithEps[{simpleRoots}][rh]]];
	   weights=Sort[ Rest[Flatten[weightSystem[{simpleRoots}][highestWeight]]], #1.rh>#2.rh&];
	   mults[highestWeight]=1;
	   insideQ:=IntegerQ[mults[toFC[#]]]&;
	   Scan[Function[v,
			 mults[v]=
			 Plus@@(fan /. {x_standardBase,e_Integer}:> If[insideQ[v+x],-e*mults[toFC[v+x]],0])],
		weights];
	   mults]


