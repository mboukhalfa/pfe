function [ classe,bel ] = comb(Ilien )
load Var_borda;

%%%%%%%%%%%%%%%%%%%%%%%% xml %%%%%%%%%%%%%%%%%%%%%%%%%%
docNode = com.mathworks.xml.XMLUtils.createDocument... 
    ('root_element')
docRootNode = docNode.getDocumentElement;
%%%%%%%%%%%%%%%%%%%%%%%% end xml%%%%%%%%%%%%%%%%%%%%%%%

I=imread(Ilien);
I=im2bw(I);
I=~I;
addpath(genpath('./extrait carcteristique'));
[ Vect_ft ] = features(I);
[ Vect_lm ] = leg_mom(I);
rmpath(genpath('./extrait carcteristique'));

addpath(genpath('./simuler'));
[ classe_nn_ft,sortie_nn_ft ] = nn_ft( Vect_ft,net_ft);
[ classe_nn_lm,sortie_nn_lm ] = nn_lm( Vect_lm,net_lm);
[ classe_svm_ft,sortie_svm_ft ] = svm_ft( Vect_ft,model_ft,minmax_svm_ft_s);
[ classe_svm_lm,sortie_svm_lm ] = svm_lm( Vect_lm,model_lm);
rmpath(genpath('./simuler'));
D=[sortie_nn_ft;
    sortie_nn_lm;
    sortie_svm_ft;
    sortie_svm_lm;
];
disp (D);

%%%%%%%%%%%%%%%%%%%% Classifieur %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% append xml
c=docNode.createElement('classe');
    b=docNode.createElement('bel');
    thisElement = docNode.createElement('nn_lm'); 
    c.appendChild... 
        (docNode.createTextNode(sprintf('%i',classe_nn_lm)));
    b.appendChild... 
        (docNode.createTextNode(sprintf('%d',sortie_nn_lm(classe_nn_lm))));
    thisElement.appendChild(c);
    thisElement.appendChild(b);
    docRootNode.appendChild(thisElement);

    c=docNode.createElement('classe');
    b=docNode.createElement('bel');
    thisElement = docNode.createElement('nn_ft'); 
    c.appendChild... 
        (docNode.createTextNode(sprintf('%i',classe_nn_ft)));
    b.appendChild... 
        (docNode.createTextNode(sprintf('%d',sortie_nn_ft(classe_nn_ft))));
    thisElement.appendChild(c);
    thisElement.appendChild(b);
    docRootNode.appendChild(thisElement);
    
    c=docNode.createElement('classe');
    b=docNode.createElement('bel');
    thisElement = docNode.createElement('svm_lm'); 
    c.appendChild... 
        (docNode.createTextNode(sprintf('%i',classe_svm_lm)));
    b.appendChild... 
        (docNode.createTextNode(sprintf('%d',sortie_svm_lm(classe_svm_lm))));
    thisElement.appendChild(c);
    thisElement.appendChild(b);
    docRootNode.appendChild(thisElement);
    
    c=docNode.createElement('classe');
    b=docNode.createElement('bel');
    thisElement = docNode.createElement('svm_ft'); 
    c.appendChild... 
        (docNode.createTextNode(sprintf('%i',classe_svm_ft)));
    b.appendChild... 
        (docNode.createTextNode(sprintf('%d',sortie_nn_ft(classe_svm_ft))));
    thisElement.appendChild(c);
    thisElement.appendChild(b);
    docRootNode.appendChild(thisElement);
%%%%%%%%%%%%%%%%%%% Methode vote majorite %%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('./Methode vote majorite'));
[classe,bel,Dc]=voteMajoritaire(D)
rmpath(genpath('./Methode vote majorite'));

%%%%%%%%%%%% append xml
c=docNode.createElement('classe');
    b=docNode.createElement('bel');
    thisElement = docNode.createElement('voteMajoritaire'); 
    c.appendChild... 
        (docNode.createTextNode(sprintf('%i',classe)));
    b.appendChild... 
        (docNode.createTextNode(sprintf('%d',bel)));
    thisElement.appendChild(c);
    thisElement.appendChild(b);
    docRootNode.appendChild(thisElement);
%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% Methode dorda %%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('./Methode borda'));
[classe,bel,Dc]=borda(D)
rmpath(genpath('./Methode borda'));

%%%%%%%%%%%% append xml
c=docNode.createElement('classe');
    b=docNode.createElement('bel');
    thisElement = docNode.createElement('borda'); 
    c.appendChild... 
        (docNode.createTextNode(sprintf('%i',classe)));
    b.appendChild... 
        (docNode.createTextNode(sprintf('%d',bel)));
    thisElement.appendChild(c);
    thisElement.appendChild(b);
    docRootNode.appendChild(thisElement);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%DS %%%%%%%%%%%%%%%%%%%%
addpath(genpath('./DS'));
load DT;
[classe,bel]=DS(D,DT);
rmpath(genpath('./DS'));

%%%%%%%%%%%% append xml
c=docNode.createElement('classe');
    b=docNode.createElement('bel');
    thisElement = docNode.createElement('DS'); 
    c.appendChild... 
        (docNode.createTextNode(sprintf('%i',classe)));
    b.appendChild... 
        (docNode.createTextNode(sprintf('%d',bel)));
    thisElement.appendChild(c);
    thisElement.appendChild(b);
    docRootNode.appendChild(thisElement);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% bks
addpath(genpath('./BKS'));
load Var_BKS;
[classe,bel]=BKS(D,unts,ResApp);
rmpath(genpath('./BKS'));
%%%%%%%%%%%% append xml
c=docNode.createElement('classe');
    b=docNode.createElement('bel');
    thisElement = docNode.createElement('BKS'); 
    c.appendChild... 
        (docNode.createTextNode(sprintf('%i',classe)));
    b.appendChild... 
        (docNode.createTextNode(sprintf('%d',bel)));
    thisElement.appendChild(c);
    thisElement.appendChild(b);
    docRootNode.appendChild(thisElement);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save the sample XML document.
xmlFileName = ['result.xml'];
xmlwrite(xmlFileName,docNode);

exit;
end

