module emission
use std_mat, only: lininterp,diff2,local_min,plot, linspace
implicit none

integer, parameter:: Ny=200,dp=8
real(dp), parameter,dimension(Ny) :: & !these are the special functions (see Kyritsakis, Xanthakis, PRSA 471:20140811) 
    vv = (/1.000000000000000e+00, 9.901487508002239e-01, 9.815990523568811e-01,9.735385052587654e-01,9.657944514409587e-01,9.582849898122546e-01,9.509621438046620e-01,9.437939679250140e-01,9.367579341725516e-01,9.298371861358989e-01,9.230186634171222e-01,9.162918241873717e-01,9.096479972736629e-01,9.030804149675133e-01,8.965829830311779e-01,8.901503987642890e-01,8.837783939899669e-01,8.774630622855859e-01,8.712009093011192e-01,8.649890650533810e-01,8.588244941766686e-01,8.527048450122413e-01,8.466279728602170e-01,8.405921698573996e-01,8.345949882169477e-01,8.286351819614325e-01,8.227111386824252e-01,8.168214188018590e-01,8.109647744130352e-01,8.051397093423305e-01,7.993453448084236e-01,7.935805392550657e-01,7.878444892870563e-01,7.821357877770025e-01,7.764539521629619e-01,7.707981061398350e-01,7.651674610258777e-01,7.595613054181773e-01,7.539789715378010e-01,7.484194923946329e-01,7.428826442049090e-01,7.373678107420274e-01,7.318741030001834e-01,7.264014059236763e-01,7.209489040937604e-01,7.155161967568670e-01,7.101029669799113e-01,7.047087080077287e-01,6.993327657426716e-01,6.939749433205432e-01,6.886348537302909e-01,6.833121155653594e-01,6.780063732231738e-01,6.727172947913285e-01,6.674444563060048e-01,6.621875170015923e-01,6.569463113632747e-01,6.517205871223191e-01,6.465099244068481e-01,6.413139630242783e-01,6.361327655966146e-01,6.309656631281146e-01,6.258127673563729e-01,6.206735740822522e-01,6.155481092099058e-01,6.104358084012765e-01,6.053368610270500e-01,6.002506752302079e-01,5.951772367709246e-01,5.901164432886615e-01,5.850679430784230e-01,5.800314714307956e-01,5.750070316723157e-01,5.699944245679107e-01,5.649934599569441e-01,5.600039562421042e-01,5.550257399122128e-01,5.500585920685797e-01,5.451024262683717e-01,5.401571050142602e-01,5.352224820426076e-01,5.302984083461624e-01,5.253846727012907e-01,5.204812022060537e-01,5.155878741643488e-01,5.107045708333732e-01,5.058311791734402e-01,5.009675906125862e-01,4.961136875835652e-01,4.912691037168074e-01,4.864339969693915e-01,4.816082751853399e-01,4.767917683714146e-01,4.719841616151277e-01,4.671856609941015e-01,4.623961033394886e-01,4.576151202714256e-01,4.528429947880911e-01,4.480793569726614e-01,4.433242129835121e-01,4.385775586513992e-01,4.338390551284855e-01,4.291089661228503e-01,4.243867851005731e-01,4.196728691135294e-01,4.149667137737938e-01,4.102686023279039e-01,4.055781952693642e-01,4.008955418859766e-01,3.962206235571218e-01,3.915531020915147e-01,3.868932530612438e-01,3.822407324956104e-01,3.775955424031231e-01,3.729577701211998e-01,3.683271031128482e-01,3.637035566567341e-01,3.590871937782671e-01,3.544778849763434e-01,3.498753504769608e-01,3.452797836412470e-01,3.406911106302504e-01,3.361092595666234e-01,3.315339415893150e-01,3.269653057332668e-01,3.224033030501724e-01,3.178478686121655e-01,3.132989391546318e-01,3.087564443036809e-01,3.042201949462451e-01,2.996902846932734e-01,2.951666561764913e-01,2.906492534459388e-01,2.861380219254216e-01,2.816329083696306e-01,2.771338608228555e-01,2.726408285792251e-01,2.681537621444056e-01,2.636726131986982e-01,2.591973345614714e-01,2.547278801568779e-01,2.502642049807954e-01,2.458062650689477e-01,2.413540174661489e-01,2.369074201966328e-01,2.324664322354155e-01,2.280310134806558e-01,2.236011247269666e-01,2.191767276396464e-01,2.147577847297865e-01,2.103442593302260e-01,2.059361155723163e-01,2.015332821858309e-01,1.971356532159229e-01,1.927432929496386e-01,1.883561686433637e-01,1.839742482442248e-01,1.795975003711649e-01,1.752258942966304e-01,1.708592517296071e-01,1.664976274499445e-01,1.621410476170106e-01,1.577894840762422e-01,1.534429092411601e-01,1.491010897296571e-01,1.447641544395267e-01,1.404321200748444e-01,1.361049612954287e-01,1.317824526245003e-01,1.274646793909447e-01,1.231517008329012e-01,1.188434746806572e-01,1.145396994344216e-01,1.102406427428393e-01,1.059462826904284e-01,1.016563417872831e-01,9.737096326668701e-02,9.309021099940061e-02,8.881381387992358e-02,8.454188344436472e-02,8.027451288980818e-02,7.601136579462732e-02,7.175266600595823e-02,6.749841745663981e-02,6.324828733292226e-02,5.900261251872982e-02,5.476114825994762e-02,5.052390532158921e-02,4.629102797114641e-02,4.206212445720553e-02,3.783758113487127e-02,3.361705982468581e-02,2.940072995229685e-02,2.518850831056418e-02,2.098030715448473e-02,1.677627349067132e-02,1.257611923377084e-02,8.380165347191253e-03,4.187978961787145e-03,0.000000000000000e+00 /), &
    tt = (/1.000000000000000e+00,1.002030781417862e+00,1.003632786824882e+00,1.005075955514299e+00,1.006417353308358e+00,1.007683957539755e+00,1.008891566532568e+00,1.010050610037040e+00,1.011168454232591e+00,1.012250589592541e+00,1.013301261227889e+00,1.014323859598625e+00,1.015321150800558e+00,1.016295389546883e+00,1.017248511247342e+00,1.018182174987559e+00,1.019097785818562e+00,1.019996584163601e+00,1.020879664647628e+00,1.021747978811433e+00,1.022602411364004e+00,1.023443726618845e+00,1.024272615800069e+00,1.025089688973000e+00,1.025895564002957e+00,1.026690735581673e+00,1.027475690358465e+00,1.028250872863402e+00,1.029016688121873e+00,1.029773532609849e+00,1.030521741770611e+00,1.031261648346635e+00,1.031993546755459e+00,1.032717751209773e+00,1.033434506233224e+00,1.034144066588887e+00,1.034846669618536e+00,1.035542537051420e+00,1.036231877908698e+00,1.036914907534409e+00,1.037591792545195e+00,1.038262712826807e+00,1.038927854335332e+00,1.039587356298646e+00,1.040241387041531e+00,1.040890087747245e+00,1.041533590044200e+00,1.042172029545119e+00,1.042805543516137e+00,1.043434242900508e+00,1.044058243348362e+00,1.044677656087644e+00,1.045292587255446e+00,1.045903138257185e+00,1.046509410981598e+00,1.047111500269847e+00,1.047709490464150e+00,1.048303466845580e+00,1.048893518817778e+00,1.049479730418012e+00,1.050062166197551e+00,1.050640917694896e+00,1.051216043057471e+00,1.051787622582175e+00,1.052355713907147e+00,1.052920395269537e+00,1.053481714557585e+00,1.054039747096986e+00,1.054594545022903e+00,1.055146162284781e+00,1.055694660205253e+00,1.056240095324423e+00,1.056782513399835e+00,1.057321965993506e+00,1.057858503006047e+00,1.058392172758164e+00,1.058923022067008e+00,1.059451098037307e+00,1.059976442316032e+00,1.060499097189592e+00,1.061019104199625e+00,1.061536503973864e+00,1.062051338074067e+00,1.062563642847344e+00,1.063073455326506e+00,1.063580811550365e+00,1.064085746605300e+00,1.064588294664522e+00,1.065088489404378e+00,1.065586370798085e+00,1.066081963100914e+00,1.066575297145695e+00,1.067066405247904e+00,1.067555322913718e+00,1.068042070814106e+00,1.068526679173990e+00,1.069009182922810e+00,1.069489599221223e+00,1.069967961869527e+00,1.070444294259226e+00,1.070918619653641e+00,1.071390969201728e+00,1.071861358501953e+00,1.072329821768765e+00,1.072796371550207e+00,1.073261040898029e+00,1.073723843463047e+00,1.074184807337213e+00,1.074643950999066e+00,1.075101294184407e+00,1.075556863526736e+00,1.076010671316672e+00,1.076462743496344e+00,1.076913097845946e+00,1.077361750009438e+00,1.077808723997548e+00,1.078254036338585e+00,1.078697702306128e+00,1.079139740968321e+00,1.079580174122345e+00,1.080019013476803e+00,1.080456276036589e+00,1.080891978476461e+00,1.081326141457119e+00,1.081758776663107e+00,1.082189899498954e+00,1.082619525426810e+00,1.083047669623051e+00,1.083474347148894e+00,1.083899575009856e+00,1.084323364713017e+00,1.084745730381644e+00,1.085166685890044e+00,1.085586244870236e+00,1.086004420718378e+00,1.086421226600978e+00,1.086836675460887e+00,1.087250780023084e+00,1.087663552800267e+00,1.088075006098254e+00,1.088485152021201e+00,1.088894002476648e+00,1.089301569180396e+00,1.089707863661225e+00,1.090112897265461e+00,1.090516681161385e+00,1.090919226343516e+00,1.091320543636742e+00,1.091720643700332e+00,1.092119537031810e+00,1.092517233970724e+00,1.092913744702279e+00,1.093309079782908e+00,1.093703250103651e+00,1.094096263974417e+00,1.094488130990864e+00,1.094878860611112e+00,1.095268462158765e+00,1.095656944825848e+00,1.096044319655648e+00,1.096430594403337e+00,1.096815777135447e+00,1.097199876540108e+00,1.097582901187470e+00,1.097964862139642e+00,1.098345765703773e+00,1.098725619561639e+00,1.099104431830844e+00,1.099482212946610e+00,1.099858969417514e+00,1.100234708029298e+00,1.100609436704620e+00,1.100983166253060e+00,1.101355900746938e+00,1.101727647595793e+00,1.102098416970978e+00,1.102468214180127e+00,1.102837045403800e+00,1.103204920390876e+00,1.103571844600817e+00,1.103937823680700e+00,1.104302867721525e+00,1.104666980816567e+00,1.105030169345461e+00,1.105392442996972e+00,1.105753804595549e+00,1.106114262768074e+00,1.106473823479837e+00,1.106832491373410e+00,1.107190276156247e+00,1.107547180034785e+00,1.107903212018282e+00,1.108258376274143e+00,1.108612679272688e+00,1.108966127420483e+00,1.109318724982190e+00,1.109670479992468e+00,1.110021395106194e+00,1.110371479424545e+00,1.110720734539592e+00 /), &
    ww = (/8.000000000000000e-01,7.990593903557062e-01,7.981212218435605e-01,7.971850716193163e-01,7.962506895376646e-01,7.953179118471086e-01,7.943866531707875e-01,7.934567967549424e-01,7.925282750106136e-01,7.916010255446501e-01,7.906749965919331e-01,7.897501209920006e-01,7.888263277835517e-01,7.879036387000090e-01,7.869820002334283e-01,7.860613472701492e-01,7.851416836616130e-01,7.842229778028280e-01,7.833051903036342e-01,7.823883315435012e-01,7.814723156121555e-01,7.805571397772499e-01,7.796427974499822e-01,7.787293322050833e-01,7.778165990366039e-01,7.769046707144984e-01,7.759935170618699e-01,7.750831196172159e-01,7.741734788014050e-01,7.732645222209847e-01,7.723562918756240e-01,7.714487578483593e-01,7.705419490885239e-01,7.696357496513833e-01,7.687302333565893e-01,7.678253773672641e-01,7.669211679764979e-01,7.660175993620985e-01,7.651146669709347e-01,7.642122909578154e-01,7.633105511245557e-01,7.624094327879908e-01,7.615088525828341e-01,7.606088972682540e-01,7.597094886173841e-01,7.588106378635329e-01,7.579123710656784e-01,7.570146661898948e-01,7.561174624569775e-01,7.552208012417980e-01,7.543246762447402e-01,7.534290789679281e-01,7.525340036541388e-01,7.516394470233185e-01,7.507453810173614e-01,7.498517943075966e-01,7.489587146945831e-01,7.480661470849971e-01,7.471740538712757e-01,7.462824091535802e-01,7.453912867492993e-01,7.445005821810872e-01,7.436103774063627e-01,7.427206035994978e-01,7.418313187646799e-01,7.409424355359369e-01,7.400540488502052e-01,7.391660610822821e-01,7.382785145323230e-01,7.373914287447291e-01,7.365047604128426e-01,7.356184861552344e-01,7.347326478010596e-01,7.338472359139018e-01,7.329622421200244e-01,7.320776590403786e-01,7.311934802272851e-01,7.303096867745417e-01,7.294262920302131e-01,7.285432956473210e-01,7.276606941730114e-01,7.267784825772383e-01,7.258966391623030e-01,7.250151764682804e-01,7.241340936738493e-01,7.232533904789240e-01,7.223730670724802e-01,7.214931241023815e-01,7.206135592443398e-01,7.197343054481833e-01,7.188554297854226e-01,7.179769346016311e-01,7.170988015262763e-01,7.162209738905005e-01,7.153435294366657e-01,7.144664498441585e-01,7.135896626254823e-01,7.127132644162992e-01,7.118371812429732e-01,7.109614366772887e-01,7.100860513209014e-01,7.092109574472614e-01,7.083362451607804e-01,7.074618015503424e-01,7.065877407427119e-01,7.057139492352485e-01,7.048405211933729e-01,7.039673856690785e-01,7.030945743065227e-01,7.022221004806966e-01,7.013498921102026e-01,7.004780402547411e-01,6.996064704755764e-01,6.987352002768673e-01,6.978642698311666e-01,6.969936118137134e-01,6.961232464350917e-01,6.952532065889611e-01,6.943834731280344e-01,6.935139859278413e-01,6.926448122914752e-01,6.917759472301522e-01,6.909073860082978e-01,6.900390646592811e-01,6.891710377861378e-01,6.883033061043673e-01,6.874358657452273e-01,6.865687130507158e-01,6.857018421806050e-01,6.848352145252686e-01,6.839688686162471e-01,6.831028015145367e-01,6.822370104572679e-01,6.813714928513894e-01,6.805062462675940e-01,6.796412684344860e-01,6.787765572329649e-01,6.779121106908332e-01,6.770479269776047e-01,6.761840043995144e-01,6.753203413947115e-01,6.744569365286324e-01,6.735937884895586e-01,6.727308960843218e-01,6.718682582341828e-01,6.710058739708529e-01,6.701437424326648e-01,6.692818628608863e-01,6.684202345961574e-01,6.675588570750687e-01,6.666977298268534e-01,6.658368524702023e-01,6.649762145174657e-01,6.641157955198331e-01,6.632556228842422e-01,6.623956965898202e-01,6.615360166902944e-01,6.606765833114356e-01,6.598173966485905e-01,6.589584148830649e-01,6.580996621472397e-01,6.572411544304840e-01,6.563828922121562e-01,6.555248760295980e-01,6.546670475669887e-01,6.538094516821134e-01,6.529521012357424e-01,6.520949970044247e-01,6.512380822956181e-01,6.503813892668515e-01,6.495249426319587e-01,6.486687379272718e-01,6.478126959530650e-01,6.469569010900136e-01,6.461013544668252e-01,6.452459833377455e-01,6.443908361595955e-01,6.435359385573338e-01,6.426812191722087e-01,6.418267171808800e-01,6.409724665326726e-01,6.401183764547567e-01,6.392645186054525e-01,6.384109008745196e-01,6.375574330096243e-01,6.367042195871654e-01,6.358511957912952e-01,6.349983711019559e-01,6.341457940200761e-01,6.332933562857685e-01,6.324411770853480e-01,6.315891635727651e-01,6.307373714298024e-01,6.298857823014392e-01,6.290343763414623e-01,6.281832026705599e-01,6.273321823616571e-01,6.264814156974592e-01,6.256307808321395e-01,6.247804132000000e-01 /), &
    psi = (/1.333333333333333e+00,1.333018024233115e+00,1.332701031413377e+00,1.332382777718021e+00,1.332063462481988e+00,1.331743219800990e+00,1.331422162060289e+00,1.331100359883384e+00,1.330777880951771e+00,1.330454780072042e+00,1.330131104829534e+00,1.329806888425339e+00,1.329482155570348e+00,1.329156960054474e+00,1.328831322965915e+00,1.328505256938984e+00,1.328178797347004e+00,1.327851963327141e+00,1.327524768508933e+00,1.327197243420925e+00,1.326869379644892e+00,1.326541198974261e+00,1.326212720264901e+00,1.325883980612838e+00,1.325554942466070e+00,1.325225651926277e+00,1.324896114017230e+00,1.324566337390244e+00,1.324236337281653e+00,1.323906099425770e+00,1.323575653936342e+00,1.323245001921238e+00,1.322914167210422e+00,1.322583115490618e+00,1.322251887322098e+00,1.321920484386648e+00,1.321588911526883e+00,1.321257176307364e+00,1.320925286409709e+00,1.320593218868366e+00,1.320261014491362e+00,1.319928675858194e+00,1.319596177472917e+00,1.319263562181622e+00,1.318930805941319e+00,1.318597920571705e+00,1.318264923692205e+00,1.317931813205207e+00,1.317598570995208e+00,1.317265220239226e+00,1.316931764557958e+00,1.316598206480150e+00,1.316264549464544e+00,1.315930797806357e+00,1.315596945492719e+00,1.315262993168529e+00,1.314928957364734e+00,1.314594845117375e+00,1.314260645869617e+00,1.313926353694029e+00,1.313592003542662e+00,1.313257556921115e+00,1.312923051920728e+00,1.312588464442063e+00,1.312253822540088e+00,1.311919094199020e+00,1.311584322552062e+00,1.311249471102565e+00,1.310914561069798e+00,1.310579604205516e+00,1.310244586153102e+00,1.309909500694144e+00,1.309574368563633e+00,1.309239189180093e+00,1.308903962321453e+00,1.308568688100718e+00,1.308233366943394e+00,1.307897994020324e+00,1.307562577848092e+00,1.307227121189610e+00,1.306891625453616e+00,1.306556091330614e+00,1.306220512499999e+00,1.305884896854858e+00,1.305549246667971e+00,1.305213564377872e+00,1.304877852577373e+00,1.304542114002722e+00,1.304206350100934e+00,1.303870535200850e+00,1.303534699659165e+00,1.303198846741950e+00,1.302862971001015e+00,1.302527050894820e+00,1.302191121124099e+00,1.301855176135410e+00,1.301519187617303e+00,1.301183198107724e+00,1.300847178591757e+00,1.300511140910904e+00,1.300175095640288e+00,1.299839016245855e+00,1.299502942413006e+00,1.299166828556455e+00,1.298830724405211e+00,1.298494584040807e+00,1.298158448766632e+00,1.297822290469760e+00,1.297486124129521e+00,1.297149957023230e+00,1.296813760453559e+00,1.296477574324301e+00,1.296141368885803e+00,1.295805153046724e+00,1.295468945241037e+00,1.295132718620175e+00,1.294796483164058e+00,1.294460254178512e+00,1.294124025028758e+00,1.293787771784801e+00,1.293451524188628e+00,1.293115281504094e+00,1.292779043080147e+00,1.292442783268936e+00,1.292106526392454e+00,1.291770274037186e+00,1.291434025837305e+00,1.291097781496767e+00,1.290761539780119e+00,1.290425285605418e+00,1.290089036421810e+00,1.289752792165304e+00,1.289416552829235e+00,1.289080318461995e+00,1.288744089164848e+00,1.288407865089826e+00,1.288071646437702e+00,1.287735433456070e+00,1.287399226437465e+00,1.287063025717571e+00,1.286726831673501e+00,1.286390644722119e+00,1.286054465318477e+00,1.285718293954241e+00,1.285382131156234e+00,1.285045977485010e+00,1.284709833533460e+00,1.284373699925540e+00,1.284037577314941e+00,1.283701466383906e+00,1.283365367842030e+00,1.283029282425125e+00,1.282693206586771e+00,1.282357132559316e+00,1.282021072787891e+00,1.281685028116350e+00,1.281348999409467e+00,1.281012987552014e+00,1.280676993447894e+00,1.280341000234313e+00,1.280005018911602e+00,1.279669057029062e+00,1.279333115571353e+00,1.278997195538133e+00,1.278661273046611e+00,1.278325367809626e+00,1.277989486007780e+00,1.277653628705530e+00,1.277317772671696e+00,1.276981932216333e+00,1.276646118494417e+00,1.276310330321828e+00,1.275974534925357e+00,1.275638768649462e+00,1.275303032648981e+00,1.274967296856635e+00,1.274631582411728e+00,1.274295900796550e+00,1.273960222510329e+00,1.273624564747406e+00,1.273288942483700e+00,1.272953317999347e+00,1.272617722187058e+00,1.272282158991539e+00,1.271946590898323e+00,1.271611062678912e+00,1.271275547550641e+00,1.270940050105779e+00,1.270604591406306e+00,1.270269126311487e+00,1.269933705718180e+00,1.269598290985304e+00,1.269262906179969e+00,1.268927544102622e+00,1.268592196921197e+00,1.268256885909111e+00,1.267921578286122e+00,1.267586316905675e+00,1.267251050867749e+00,1.266915967611353e+00 /)
real(dp), parameter :: pi=acos(-1.d0),b=6.83089d0,zs=1.6183d-4,gg=10.246d0, &
                         Q=0.35999d0, kBoltz=8.6173324d-5
logical, save:: spectroscopy= .false.
!tabulated special elliptic functions. Couldn't find better way to load them as module parameters

interface!interface to pass function pointers
    pure function fun_temp(x) result(y)
        real(8), intent(in)::x
        real(8):: y
    end function fun_temp
end interface

 contains
 

function Jcur(F,W,R,gamma,T,regime,heat) result(J)
!calculates current and Nottingham for many input values
    real(dp),intent(in)::F(:),W,R,gamma,T
    character,intent(out),optional::regime(:)
    real(dp), intent(out):: heat(:)
    real(dp)::J(size(F))
    integer:: i,N,nthread
    N=size(F)

    do i=1,N
        J(i)=Cur_dens(F(i),W,R,gamma,T,regime(i),heat(i))
    enddo
!   call plot(1.d0/F,log(J))
    
end function Jcur

function Cur_dens(F,W,R,gamma,T,regime,heat) result (Jem)
!Calculates current density, main module function
    real(dp), intent(in)::F,W,R,T,gamma !F: local field, 
    !W: work function, R: Radius of curvature, gamma:total enhancement kT: boltzmann*temperature 
    real(dp):: Gam(4),maxbeta,minbeta,kT,Jem,Jf,Jt,n,s,Um,xm,E0,dE,heatf,heatt
    real(dp), intent(out):: heat
    real(dp), parameter:: nlimf=.7d0, nlimt=2.5d0
    character,intent(out),optional::regime

    Um=-1.d20
    xm=-1.d20
    kT=kBoltz*T
    Gam=Gamow_general(F,W,R,gamma,Um,xm)
    maxbeta=Gam(2)
    minbeta=Gam(3)
    
    if(kT*maxbeta<nlimf) then!field regime
        Jem=zs*pi*kT*exp(-Gam(1))/(maxbeta*sin(pi*maxbeta*kT))!Murphy-Good version of FN
        heat=-zs*pi*pi*kT*kT*exp(-Gam(1))*cos(pi*maxbeta*kT)  &
        /(maxbeta*(sin(pi*maxbeta*kT)**2))
        regime='f'
    else if (kT*minbeta>(nlimt)) then!thermal regime
        n=1.d0/(kT*minbeta)
        s=minbeta*Um
        Jf = zs*(minbeta**(-2))*Sigma(1.d0/n)*exp(-s);
        Jt = zs*(kT**2)*exp(-n*s)*Sigma(n)
        Jem = Jt+Jf/(n**2)
        heatt=(n*s+1.d0)*Sigma(n)*exp(-n*s)
        heatf=(n**3)*DSigma(1/n)*exp(-s)
        heat=zs*(heatt+heatf)*(kT**3)
        regime='t'
    else!intermediate regime
        Jem=J_num_integ(F,W,R,gamma,T,heat)
        regime='i'
    endif
end function Cur_dens 

function Gamow_general(F,W,R,gamma,Um,xm) result (Gam)
!Calculates [G, dG/dW@Ef, dG/dW@Umax, Umax] where G is Gamow exponent and
!Umax is maximum of barrier and returns a vector with the four values 
    real(dp), intent(in)::F,W,R,gamma !F: local field, 
    !W: work function, R: Radius of curvature, kT: boltzmann*temperature
    real(dp), intent(inout):: Um,xm
    real(dp),parameter::dw=1.d-2,xlim=0.08d0
    real(dp):: Gam(4),x,yf,xmax,work
    
    work=W
    x=W/(F*R)
    yf=1.44d0*F/(W**2)

    if (x>xlim) then !not x<<1, use numerical integration
        if (x>0.4d0) then !the second root is far away
            xmax=W*gamma/F
        else!the second root is close to the standard W/F
            xmax=2.d0*W/F
        endif
        Gam(1)=Gamow_num(SphBar,xmax,Um,xm)
        Gam(4)=Um
        if (abs(Um-(W-F*R))<.2d0) then ! almost without maximum
            Gam(3)=1.d20
        else
            Gam(3)=22.761d0/sqrt(abs(diff2(SphBar,xm)))
        endif
        if (Um<0.d0) then !barrier lost
            Gam(2)=0.d0
        elseif (Gam(1)==1.d20) then
            Gam(2)=1.d20
        else
            work=W+dw
            Gam(2)=abs((Gamow_num(SphBar,xmax,Um,xm)-Gam(1))/dw)
        endif
    else !large radius, KX approximation usable
        Gam(4)=W-2.d0*sqrt(F*Q)-0.75d0*Q/R
        Gam(3)=16.093d0/sqrt(F**1.5d0/sqrt(Q)-4*F/R)
        Um=Gam(4)
        xm=sqrt(Q/F)+Q/(F*R)
        if (Gam(4)<0.d0) then
            Gam(1:2)=0.d0
        else
            Gam(1)=Gam_KX(F,W,R)
            Gam(2)=maxbeta_KX(F,W,R)
        endif
    endif
        
    contains
    pure function SphBar(x) result(V)!sphere barrier model
        real(dp), intent(in) :: x
        real(dp)::V
        V= work   -(F*R*x*(gamma-1.d0)+F*x**2) / (gamma*x+R*(gamma-1.d0)) &
          -Q/(x+(0.5d0*(x**2))/R)
    end function SphBar
end function Gamow_general

function J_num_integ(F,W,R,gamma,T,heat) result(Jcur)
!numerical integration over energies to obtain total current according
!to landauer formula
    real(dp), intent(in)::F,W,R,T,gamma !F: local field,
    !W: work function, R: Radius of curvature, kT: boltzmann*temperature
    real(dp), intent(out) :: heat
    real(dp), parameter:: cutoff=1.d-4 !cutoff of the exponentially decreasing
    integer, parameter::Nvals=512, fidout=1953!no of intervals for integration
    real(dp):: kT,Gam(4),Gj(4),Um,xm,G(4*Nvals),Ej,dE,Ea,Eb,insum, &
    Jsum,Jcur,Umax,Emax,Emin,E0,Gup(2*Nvals),Gdown(2*Nvals),fj,fmax,integrand,outsum
    integer::j,i,k

    if (spectroscopy) then
        open(fidout,file='spectra.csv')
    endif
    Um=-1.d20
    xm=-1.d20
    kT=kBoltz*T
    Gam=Gamow_general(F,W,R,gamma,Um,xm)
    
    if (Gam(1)==0.d0) then!if no barrier for fermi electrons
        Jcur=1.d20
        return
    endif

    if(kT*Gam(2)<1.05d0) then!field regime, max is close to Ef
        Emax=abs(log(cutoff))/(1.d0/kT-.7*Gam(2))
        Emin=-abs(log(cutoff))/Gam(2)
        E0=0.d0
    else if (kT*Gam(3)>.95d0) then!thermal regime, max is close to Um
        Emax=Um+abs(log(cutoff))*kT
        Emin=Um-abs(log(cutoff))/(Gam(3)-0.7/kT)
        E0=Um
    else! integmediate regime, max is in between ,find it
        Ea=0.d0
        Eb=Um
        do j=1,100!bisection to find where n=1
            Ej=(Eb+Ea)*.5d0
            Umax=Um-Ej
            Gj=Gamow_general(F,W-Ej,R,gamma,Umax,xm)
            if ((kT*Gj(2))<0.98d0) then
                Eb=Ej
            else if (Gj(2)*kT>1.02d0) then
                Ea=Ej
            else
                exit
            endif
        enddo
        Emax=Um
        Emin=0.d0
        E0=Ej
    endif
    
    dE=(Emax-Emin)/(Nvals-1)
    Jsum=0.d0
    insum=0.d0
    outsum=0.d0
    fmax=0.d0
    
    do j=1,2*Nvals!integrate over high energies
        Ej=E0+(j-1)*dE
        Umax=Um-Ej
        if (Umax>0.d0) then
            Gj=Gamow_general(F,W-Ej,R,gamma,Umax,xm)
        else
            Gj(1)=Gam(3)*Umax
        endif
        if ( .not. isnan(Gam(1)) ) then
            Gup(j)=Gj(1)
        endif
        fj=lFD(Ej,kT)/(1.d0+exp(Gup(j)))
        if (fj>fmax) then
            fmax=fj
        endif
        if (abs(fj/fmax)<cutoff)  then
            exit
        endif
        Jsum=Jsum+fj
    enddo
    do i=1,2*Nvals!integrate over low energies
        Ej=E0-i*dE
        Umax=Um-Ej
        if (Umax>0.d0) then
            Gj=Gamow_general(F,W-Ej,R,gamma,Umax,xm)
        else
            Gj(1)=Gam(3)*Umax
        endif
        if ( .not. isnan(Gam(1)) ) then
            Gdown(i)=Gj(1)
        endif
        fj=lFD(Ej,kT)/(1.d0+exp(Gdown(i)))
        if (fj>fmax) then
            fmax=fj
        endif
        if (abs(fj/fmax)<cutoff)  then
            exit
        endif
        Jsum=Jsum+fj
    enddo
    Jcur=Jsum*zs*kT*dE
    
    G(1:i+j)=[Gdown(i:1:-1),Gup(1:j)]!bring G vectors together and in correct order
    do k=1,i+j!integrate for nottingham effect
        integrand=Ej*(insum+.5d0*dE/(1.d0+exp(G(k))))/(1.d0+exp(Ej/kT))
        insum=insum+dE/(1.d0+exp(G(k)))
        outsum=outsum+integrand
        if (spectroscopy) then
            print *, fidout
            write(fidout,*) Ej,',',integrand,',',integrand/Ej
        endif
        Ej=Ej+dE
    enddo

    heat=zs*outsum*dE
    
    if (spectroscopy) then
        close(fidout)
    endif

    contains
    pure function lFD(E,kT) result(L)
        real(dp), intent(in)::E,kT
        real(dp) :: L
        if (E>10.d0*kT) then
            L=exp(-E/kT)
        else
            L=log(1.d0+exp(-E/kT))
        endif
    end function lFD
end function J_num_integ

pure function maxbeta_KX(F,W,R) result(beta)
!dG/dE at Efermi    
    real(dp), intent(in):: F,W,R
    real(dp) :: yf,t,ps,beta
    
    yf = 1.44d0*F/(W**2)
    if (yf>1.d0) then
        beta=0.d0
        return
    endif
    t = lininterp(tt,0.d0,1.d0,yf)
    ps = lininterp(psi,0.d0,1.d0,yf)
    beta = gg*(sqrt(W)/F)*(t+ps*(W/(F*R)))
end function maxbeta_KX

pure function Gam_KX(F,W,R) result(Gam)
!gives the KX approximation for Gamow
    real(dp), intent(in):: F,W,R
    real(dp) :: yf,v,omeg,Gam

    yf = 1.44d0*F/(W**2)
        if (yf>1.d0) then
        Gam=0.d0
        return
    endif
    v = lininterp(vv,0.d0,1.d0,yf)
    omeg = lininterp(ww,0.d0,1.d0,yf)
    Gam = b*((W**1.5d0)/F)*(v+omeg*(W/(F*R)))
end function Gam_KX

function Gamow_num(Vbarrier,xmax,Um,xm) result(G)
!calculate Gamow by numerical integration
    real(dp), intent(in)::xmax
    real(dp), intent(inout)::Um,xm
    procedure(fun_temp)::Vbarrier
    
    integer, parameter ::maxint=500
    real(dp), parameter :: AtolRoot=1.d-7, RtolRoot=1.d-7, &
    AtolInt=1.d-5, RtolInt=1.d-5
    real(dp):: G, x ,x1(2),x2(2), ABSERR
    real(dp), dimension(maxint) :: ALIST,BLIST,RLIST,ELIST
    integer :: iflag,NEVAL,IER,IORD(maxint),LAST

    x=1.d-5
    if (Um == -1.d20) then
        Um=-local_min(x,xmax,1.d-8,1.d-8,negBarrier,xm)
    endif
    if (Um<0.d0) then
        G=0.d0
        return
    endif
    
    if (Vbarrier(xmax)>0) then
        G=1.d20
        return
    endif

    x1=(/0.01d0,xm/)
    x2=(/xm,xmax/)
    call dfzero(Vbarrier,x1(1),x1(2),x1(1),RtolRoot,AtolRoot,iflag)
    call dfzero(Vbarrier,x2(1),x2(2),x2(1),RtolRoot,AtolRoot,iflag)
    call dqage(sqrtVbarrier,x1(2),x2(1),AtolInt,RtolInt,2,1000,G,ABSERR, &
    NEVAL,IER,ALIST,BLIST,RLIST,ELIST,IORD,LAST)
    G=gg*G

    contains
    pure function negBarrier(x) result(nv)
        real(dp), intent(in)::x
        real(dp)::nv
        nv=-Vbarrier(x)
    end function negBarrier
    
    pure function sqrtVBarrier(x) result(rv)
        real(dp), intent(in)::x
        real(dp)::rv
        rv=sqrt(Vbarrier(x))
    end function sqrtVBarrier
end function Gamow_num

function surf_points(phi) result(inds2)

real(dp), intent(in)        :: phi(:,:,:)
integer , allocatable       :: inds2(:,:), inds(:,:)

integer                     :: i,j,k,Nx,Ny,Nz,N,icount, sz(3)

sz=shape(phi)
Nx=sz(1)
Ny=sz(2)
Nz=sz(3)
N=Nx*Ny*Nz
allocate(inds(3,N))

icount=1
do k=2,Nz-1
    do j=2,Ny-1
        do i=2,Nx-1
            if (phi(i,j,k)<1.d-8 .and. ( &
                    phi(i+1,j,k)>1.d-8 .or. phi(i-1,j,k)>1.d-8 .or. &
                    phi(i,j+1,k)>1.d-8 .or. phi(i,j-1,k)>1.d-8 .or. &
                    phi(i,j,k+1)>1.d-8 .or. phi(i,j,k-1)>1.d-8)) &
                    then
                inds(:,icount)=[i,j,k]
                
                icount=icount+1
            endif
        enddo
    enddo
enddo

allocate(inds2(3,icount-1))
inds2=inds(:,1:icount-1)
deallocate(inds)

end function surf_points

function J_from_phi(phi,grid_spacing,Nstart,W,T,heat,times) result(Jcur)
    use bspline, only: db3ink,db3val
    
    real(dp),intent(in)     :: phi(:,:,:),grid_spacing(3),T,W
    real(dp), intent(out)   :: heat(:),times(4)
    integer, intent(in)     :: Nstart(:,:)
    
    integer, parameter      :: kx=2, ky=2, kz=2, iknot=0, nline=64
    
    integer                 :: inbvx=1,inbvy=1,inbvz=1,iloy=1,iloz=1
    integer                 :: idx=0, idy=0, idz=0, iflag
    real(dp), allocatable   :: fcn(:,:,:), tx(:), ty(:), tz(:), x(:), y(:), z(:)
    !the above are spline-related parameters
    
    integer                 :: nx, ny, nz, sz(3), i,j, istart, jstart, kstart, Npoints
    real(dp), dimension(3)  :: direc, Efstart
    real(dp), dimension(nline):: xline, yline, zline, V
    
    real(dp)                :: Jcur(size(Nstart,2)),ti(5)
    real(dp)                :: F,R,gamma, Vline(nline), rline(nline)
    real(dp)                :: tinterp=0.d0, tfit=0.d0, tcur=0.d0, t2,t1
    
    character               :: regime
    
    call cpu_time(t1)
    rline=linspace(0.d0,3.d0,nline)
    
    sz=shape(phi)
    nx=sz(1)
    ny=sz(2)
    nz=sz(3)
    Npoints=size(Nstart,2)
    

    allocate(x(nx),y(ny),z(nz),fcn(nx,ny,nz),tx(nx+kx),ty(ny+ky),tz(nz+kz))
    x=[(grid_spacing(1)*(i-1), i=1,nx)]
    y=[(grid_spacing(2)*(i-1), i=1,ny)]
    z=[(grid_spacing(3)*(i-1), i=1,nz)]
    call db3ink(x,nx,y,ny,z,nz,phi,kx,ky,kz,iknot,tx,ty,tz,fcn,iflag)
    call cpu_time(t2)
    print *, 'Interpolation set:', t2-t1
    do j=1,Npoints
    
        istart=Nstart(1,j)
        jstart=Nstart(2,j)
        kstart=Nstart(3,j)
    
    !find direction of the line (same as Efield direction)
        Efstart=([phi(istart+1,jstart,kstart), &
                 phi(istart,jstart+1,kstart), &
                 phi(istart,jstart,kstart+1)]-[phi(istart-1,jstart,kstart), &
                 phi(istart,jstart-1,kstart), &
                 phi(istart,jstart,kstart-1)])/grid_spacing
                 
        if (norm2(Efstart)>1.d0) then
            direc=Efstart/norm2(Efstart)
            !set the line of interpolation and interpolate
            xline=x(istart)+rline*direc(1)
            yline=y(jstart)+rline*direc(2)
            zline=z(kstart)+rline*direc(3)
            
            call cpu_time(t1)
            do i=1,nline
                call db3val(xline(i),yline(i),zline(i),idx,idy,idz,tx,ty,tz,nx,ny,nz, &
                        kx,ky,kz,fcn,Vline(i),iflag,inbvx,inbvy,inbvz,iloy,iloz)
            enddo
            call cpu_time(t2)
            tinterp=tinterp+t2-t1
            
            call cpu_time(t1)
            call fitpot(rline,Vline,F,R,gamma)
            call cpu_time(t2)
            tfit=tfit+t2-t1
            
            call cpu_time(t1)
            if (F>0.d0) then
                Jcur(j)=Cur_dens(F,W,R,gamma,T,regime,heat(j)) !calculate current
            else
                Jcur(j)=1.d-200
            endif
            call cpu_time(t2)
            tcur=tcur+t2-t1
        else
            Jcur(j)=1.d-200
        endif
        
    enddo

    print *, 'Interpolation: ', tinterp, 'sec'
    print *, 'Fitting:', tfit, 'sec'
    print *, 'Current:', tcur,'sec'

end function J_from_phi

function pot_interp(phi,grid_spacing,Nstart,r,timings) result(V)

    use bspline, only: db3ink,db3val
    
    real(dp), intent(in)    :: phi(:,:,:), grid_spacing(3), r(:)
    integer, intent(in)     :: Nstart(:)
    real(dp), intent(out)   :: timings(2)
    !everything comes in in nm
    
    integer, parameter      :: kx=2, ky=2, kz=2, iknot=0
    integer                 :: inbvx=1,inbvy=1,inbvz=1,iloy=1,iloz=1
    integer                 :: idx=0, idy=0, idz=0, iflag
    real(dp), allocatable   :: fcn(:,:,:), tx(:), ty(:), tz(:), x(:), y(:), z(:)
    !the above are spline-related parameters
    
    integer                 :: nx, ny, nz, sz(3), i, nline, istart, jstart, kstart
    real(dp), dimension(3)  :: direc, Efstart
    real(dp), dimension(size(r))  :: xline, yline, zline, V
    
    real(dp)                :: t1,t2,t3
    
    call cpu_time(t1)
    !setup parameters and allocate memory for interpolating
    sz=shape(phi)
    nx=sz(1)
    ny=sz(2)
    nz=sz(3)
    nline=size(r)
    allocate(x(nx),y(ny),z(nz),fcn(nx,ny,nz),tx(nx+kx),ty(ny+ky),tz(nz+kz))
    x=[(grid_spacing(1)*(i-1), i=1,nx)]
    y=[(grid_spacing(2)*(i-1), i=1,ny)]
    z=[(grid_spacing(3)*(i-1), i=1,nz)]
    call db3ink(x,nx,y,ny,z,nz,phi,kx,ky,kz,iknot,tx,ty,tz,fcn,iflag)
    
    call cpu_time(t2)
    istart=Nstart(1)
    jstart=Nstart(2)
    kstart=Nstart(3)
    
    !find direction of the line (same as Efield direction)
    Efstart=([phi(istart+1,jstart,kstart), &
             phi(istart,jstart+1,kstart), &
             phi(istart,jstart,kstart+1)]-[phi(istart-1,jstart,kstart), &
             phi(istart,jstart-1,kstart), &
             phi(istart,jstart,kstart-1)])/grid_spacing
    direc=Efstart/norm2(Efstart)
!     print *, 'direc=' , direc
    !set the line of interpolation and interpolate
    xline=x(istart)+r*direc(1)
    yline=y(jstart)+r*direc(2)
    zline=z(kstart)+r*direc(3)
    
    do i=1,nline
        call db3val(xline(i),yline(i),zline(i),idx,idy,idz,tx,ty,tz,nx,ny,nz, &
                    kx,ky,kz,fcn,V(i),iflag,inbvx,inbvy,inbvz,iloy,iloz)
    enddo
    
    call cpu_time(t3)
    
    timings=[t2-t1,t3-t2]
    
    deallocate(x,y,z,fcn,tx,ty,tz)
    
end function pot_interp

subroutine fitpot(x,V,F,R,gamma)
    !Fits V(x) data to F,R,gamma standard potential using L-V
    !minimization module
    use Levenberg_Marquardt, only: nlinfit
    
    real(dp), intent(in)    ::x(:),V(:)
    real(dp), intent(out)   ::F,R,gamma
    real(dp)                ::p(3),F2,Fend,var
    
    integer                 :: Nstart=4

    
    p(1) = (V(Nstart)-V(Nstart-1))/(x(Nstart)-x(Nstart-1))
    F2 = (V(Nstart+1)-V(Nstart))/(x(Nstart+1)-x(Nstart))
    Fend = (V(size(V))-V(size(V)-1))/(x(size(x))-x(size(x)-1))
    p(2) = abs(2.d0/((F2-p(1))/(x(Nstart)-x(Nstart-1))))
    p(3) = p(1)/Fend
!     print *, 'F,R,gamma first guess =', p
    var=nlinfit(fun,x,V,p)
    F=p(1)
    R=p(2)
    gamma=p(3)

    contains

    pure function fun(x,p) result(y)
        real(dp), intent(in) :: x
        real(dp), intent(in) :: p(:)
        real(dp)             :: y
        y=(p(1)*p(2)*x*(p(3)-1.d0)+p(1)*x**2) / (p(3)*x+p(2)*(p(3)-1.d0))
    end function fun
end subroutine fitpot
    
    
pure function Sigma(x) result(Sig)
    double precision, intent(in) :: x
    double precision:: Sig
    Sig = (1.d0+x**2)/(1.d0-x**2)-.3551d0*x**2-0.1059d0*x**4-0.039*x**6!Jensen's sigma
end function Sigma

pure function DSigma(x) result(ds)
    real(dp), intent(in):: x
    real(dp):: ds
    ds=(-1.d0+4.d0*x**2+x**4)/(1.d0-x**2)-.3551d0*x**2-.3178d0*x**4-0.027066*x**6!Jensen's sigma'
end function DSigma

end module
