% !TEX encoding = UTF-8
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
\NeedsTeXFormat{LaTeX2e}[2019/06/13]%
%
\ProvidesClass{eval}%
%
\RequirePackage{pgfopts}%
%
\RequirePackage{scrlfile}% pour \AfterClass
%
\RequirePackage{mys-input-path}%
%
\@ifpackageloaded{datenumber}%
  {%
      \@ifpackagewith{datenumber}{french}{}{\PassOptionsToPackage{french}{datenumber}}%
    }%
  {%
  \PassOptionsToPackage{french}{datenumber}%
  \RequirePackage{datenumber}%
  \def\@datedatefrench{\datedayname \space \thedateday \ifnum 1=\thedateday \/$^{\rm er}$\fi \space \datemonthname \space \number \thedateyear}
  }
%
\RequirePackage{xfp}%
\RequirePackage{etoolbox}%\ifblank
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%  Initialisation des macros stockant les options de la classe (pour les clés qui ne peuvent avoir aucune valeur). Pour les clés qui doivent être appelées et avec une valeur (non vide), les macros les stockant ne doivent pas être initialisées (pour lever une erreur en cas d'oubli d'appel ou si la valeur donnée est vide).
%
\def\@eval@annee@first{}%
\def\@eval@date{}%
\def\@eval@duree{}%
\def\@eval@classe{}%
\def\@eval@niveau{}%
\def\@eval@specialite{}%
\def\@eval@division{}%
\def\@eval@matiere{}%
\def\@eval@genre{}%
\def\@eval@sousgenre{}%
\def\@eval@bareme{}%
\def\@eval@contenu{}%
\def\@eval@chemin{}%
\def\@eval@genre@num{0}%
\def\@eval@num{0}%
%
% Déclaration de booléen
%
\newif \if@noduree
\newif \if@nodate
\newif \if@nobareme
\newif\if@page@pleine%
\newif\if@version%
\newif\if@PAP%
\newif\if@nonum%
\newif \if@noname%
\newif\if@iipagesuri%
\newif\if@iipagesurinofiles%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Macros utiles lors de la déclaration des clés
%
% Calcul de l'année de début de l'année scolaire courante au moment de la compilation
%
\def\scolaire@anneei{\ifnum\month> 8 \year\else\number\numexpr\year-1\relax\fi}%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Définition des options globales par défaut
%
\def\eval@classoptions{10pt,a4paper,french}
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Définitions des clés
%
\pgfkeys{%
    /eval/.cd,%
%
%----------% Année 
%
    annee/.store in=\@eval@annee@first,%
    annee/.default=\scolaire@anneei,%
%
%----------% Date de l'éval 
%
    date/.store in = \@eval@date,%
%
    no-date/.is if=@nodate,%
    no-date/.initial=false,%
    no-date/.default=true,%
%
%----------% Durée de l'éval 
%
    duree/.store in  = \@eval@duree,%
%
    no-duree/.is if=@noduree,%
    no-duree/.initial=false,%
    no-duree/.default=true,%
%
%----------% Classe
%
    classe/.store in=\@eval@classe,%
%
%----------% Niveau
%
    niveau/.store in=\@eval@niveau,%
    niveau/.value required,%
%
%----------% Spécialité 
%
    specialite/.store in=\@eval@specialite,%
%
%----------% Division 
%
    division/.store in=\@eval@division,%
%
%----------% Matière 
%
    matiere/.store in=\@eval@matiere,%
    matiere/.value required,%
%
%----------% Genre 
%
    genre/.store in = \@eval@genre,%
    genre/.value required,%
%
%----------% Sous-genre 
%
    sousgenre/.store in = \@eval@sousgenre,%
    sousgenre/.value required,%
%
%----------% Barème 
%
    bareme/.store in = \@eval@bareme,%
    bareme/.initial=0,%
    bareme/.default=0,%
%
    no-bareme/.is if=@nobareme,%
    no-bareme/.initial=false,%
    no-bareme/.default=true,%
%
%----------% Contenu 
%
    contenu/.store in=\@eval@contenu,%
%
%----------% Chemin des sources des chapitres
%
    chemin/.store in=\@eval@chemin,%
%    chemin/.code=\AtBeginDocument{\mys@fichier@path{#1}},%
%
%----------% Chemin des images
%
    chemin-graph/.code={\ifblank{#1}{}{\AfterClass{eval}{\graphicspath{#1}}\fi}},%
%
%----------% Page pleine 
%
    page-pleine/.is if=@page@pleine,%
    page-pleine/.initial=false,%
    page-pleine/.default=true,%
%
%----------% Version 
%
    version/.is if=@version,%
    version/.initial=false,%
    version/.default=true,%
%
%----------% PAP
%
    PAP/.is if=@PAP,%
    PAP/.initial=false,%
    PAP/.default=true,%
%
%----------% Numérotation par genre ou globale
%
    num-par-genre/.code = \def\eval@count@chosen{\arabic{mys@eval@count@\@eval@genre}},%
    num-globale/.code =  \def\eval@count@chosen{\arabic{mys@eval@count@eval}},%
%
%----------% Numéro de l'éval suivant le genre
%
    eval-genre-num/.store in = \@eval@genre@num,%
    eval-genre-num/.initial = 0,%
    eval-genre-num/.default = 0,%
%
%----------% Numéro global de l'éval
%
    eval-num/.store in = \@eval@num,%
    eval-num/.initial = 0,%
    eval-num/.default = 0,%
%
    no-num/.is if=@nonum,%
    no-num/.initial=false,%
    no-num/.default=true,%
%
%----------% Pas de nom
%
    no-name/.is if=@noname,%
    no-name/.initial=false,%
    no-name/.default=true,%
%
%----------% 2 pages sur 1
%
    2pagessur1/.is choice,%
    2pagessur1/1/.is if = @iipagesuri,%
    2pagessur1/1/.default = true,%
    2pagessur1/2/.is if = @iipagesurinofiles,%
    2pagessur1/2/.default = true,%
%    2pagessur1/.is if=@iipagesuri,%
%    2pagessur1/.default=true,%
%
%----------% Aliases 
%
    ci/.style={genre=ci},%
    cf/.style={genre=cf},%
    massicot/.style={genre=#1,page-pleine},%
%    corr/.style={sousgenre=#1, no-name,no-duree,no-bareme,PAP=false},%
    qcm_corr/.code = \AtBeginDocument{\ifdefined\SetQcm\SetQcm{corr}\fi},
    corr/.is choice,%
    corr/c/.style={sousgenre=corr,no-date,no-name,no-duree,no-bareme,PAP=false,qcm_corr},%
    corr/C/.style={sousgenre=Corr,no-date,no-name,no-duree,no-bareme,PAP=false,qcm_corr},%
    corr/(/.style={sousgenre=pcorr,no-date,no-name,no-duree,no-bareme,PAP=false,qcm_corr},%
    grille/.style={sousgenre=ge,no-date,no-name,no-duree,no-bareme,PAP=false},
%
%----------% Clés inconnues 
%
    .unknown/.code={\edef\eval@classoptions{\eval@classoptions,\pgfkeyscurrentname}},%
    }%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Valeurs par défaut de clés
%
\pgfkeys{%
    /eval/.cd,%
    annee,% si la clé annee n'est pas appelée ... elle le sera quand même :)
    num-par-genre,%
    matiere=m,%
    PAP=false,%
    2pagessur1/1=false,%
    2pagessur1/2=false,%
    }%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Acquisition des valeurs des clés (?)
%
\ProcessPgfOptions{/eval}%
%
\edef\@classoptionslist{\eval@classoptions}
%
\LoadClass[\@classoptionslist]{article}
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%---------------------------------------------------------------------------------------------------------------------------------------------------
% PROBLÈME :
%    \RequirePackage{mys-objet} doit être après \ProcessPgfOptions{/eval} sinon :
%            \eval@niveau (ou la macro de stockage correspondante pour toute clé dont la valeur est donnée
%            en option lors de \documentclass[ ... ]{eval})  est vide (la valeur saisie en option n'est pas
%            stockée dans la macro). 
%    POURQUOI ???
%---------------------------------------------------------------------------------------------------------------------------------------------------
%
\RequirePackage{mys-objet}%
%
\input{mys-objet-eval-setup.tex}
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Interfaces
%
%----------% Interface de définition des options de la classe
%
\newcommand*{\SetEval}[1]{\pgfqkeys{/eval}{#1}}%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Traitement des valeurs des clés et interfaces
%
%----------% Calcul de la date de l'éval
%
\def\@eval@set@evaldate#1{\@eval@set@evaldate@aux#1///*}%
%
\def\@eval@set@evaldate@aux#1/#2/#3/#4*{%
    \setcounter{dateday}{#1}%
    \ifx\relax#2\relax%
        \setcounter{datemonth}{\month}%
    \else %
        \setcounter{datemonth}{#2}%
    \fi%
    \ifx\relax#3\relax %
        \ifnum\value{datemonth}>08 %
            \setcounter{dateyear}{\@eval@annee@first}%\@eval@annee@first ?
        \else %
            \setcounter{dateyear}{\numexpr\@eval@annee@first+1\relax}%
        \fi%
    \else%
        \setcounter{dateyear}{#3}%
    \fi%   
    \setdatenumber{\thedateyear}{\thedatemonth}{\thedateday}%
}%
%
%    Définition de la date de l'éval
%
\newcommand\Setevaldate[1]{\@eval@set@evaldate{#1}}
%
%    Traitement de la clé
%
\expandafter\Setevaldate\expandafter{\@eval@date}%
%
%----------% Durée de l'éval
%
%    Définition de la durée de l'éval
%
\newcommand\Setevalduree[1]{\@eval@set@duree{#1}}
%
%    Définition de l'affichage de la durée
%
\def\@eval@set@duree#1{\@eval@set@duree@aux#1hhm}%
%
\def\@eval@set@duree@aux#1h#2h#3m{%
    \ifx\relax#3\relax
        \gdef\@duree{\SI{#1}{\minute}}%
    \else
        \ifx\relax#2\relax
            \gdef\@duree{\SI{#1}{\hour}}%
        \else
            \gdef\@duree{\SI{#1}{\hour}~\SI{#2}{\minute}}
        \fi
    \fi%   
}%
%
%    Traitement de la clé
%
\expandafter\Setevalduree\expandafter{\@eval@duree}%
%
%----------% Barème
%
%    Définition du barème
%
\newcommand\Setbareme[1]{\@eval@set@bareme{#1}}
%
%    Définition de l'affichage
%
\def\@eval@set@bareme#1{\ifnum#1=0\set@bareme{\ptscalcules}\else\set@bareme{#1}\fi}%
%
\def\set@bareme#1{\gdef\@bareme{#1~pt\ifnum1=\fpeval{#1<1?0:1}s\fi}}
%
%    Traitement de la clé
%
\expandafter\Setbareme\expandafter{\@eval@bareme}%
%
%----------% Chemin des sources des chapitres
%
%    Définition du chemin 
%
\newcommand\Setchemin[1]{\mys@fichier@path{#1}}%
%
%    Traitement de la clé
%
\expandafter\ifblank\expandafter{\@eval@chemin}%
    {}%
    {\AfterClass{eval}{\expandafter\Setchemin\expandafter{\@eval@chemin}}}%
%
%----------% Définition du chemin des graphiques
%
%\ifx\relax\@eval@chemin@graphique\relax\else\show\@eval@chemin@graphique\AfterClass{eval}{\graphicspath{\@eval@chemin@graphique}}\fi
%
%----------% Page pleine
%
%    Traitement de la clé
%
\if@page@pleine \AfterEndPreamble{\renewcommand\maketitle{\pagepleine}}\fi
%
%----------% Numérotation globale de l'éval 
%
%    Initialisations
%
\newcounter{mys@eval@count@eval}
\setcounter{mys@eval@count@eval}{-1}
%
%        Définition du numéro global de l'éval
%
\newcommand\Setnumeval[1]{%
    \setcounter{mys@eval@count@eval}{\numexpr#1-1\relax}%
    \refstepcounter{mys@eval@count@eval}%
    }%
%
%    Traitement de la clé
%
\ifnum\@eval@num>0 
    \expandafter\Setnumeval\expandafter{\@eval@num}%
\fi
%
%----------% Numérotation par genre de l'éval 
%
%    Initialisations
%
%    ????
%
%    Définition du numéro global de l'éval
%
\newcommand\Setnumevalgenre[2]{%
    \setcounter{mys@eval@count@#1}{\numexpr#2-1\relax}%
    \refstepcounter{mys@eval@count@#1}%
    }%
%
%    Traitement de la clé
%
\ifnum\@eval@genre@num>0 
    \edef\mys@tmp{{\@eval@genre}{\@eval@genre@num}}
    \expandafter\Setnumevalgenre\mys@tmp%
\fi
%
%----------% Version
%
\AtBeginDocument{% \AtEndPreamble ?
    \if@version %
        \expandafter\def\expandafter\eval@count@chosen\expandafter{\eval@count@chosen{\small\alph{mys@eval@vers}}}
%
        \providecommand\theHpage{\themys@eval@vers.\arabic{page}}%
        \setcounter{mys@eval@vers}{0}%
        \numberwithin{exr}{mys@eval@vers}%
        \numberwithin{question}{mys@eval@vers}%
        \providecommand{\theHexr}{\themys@eval@vers.\arabic{exr}}%
        \providecommand{\theHquestion}{\themys@eval@vers.\arabic{exr}.\arabic{question}}%
        \renewcommand{\theexr}{\arabic{exr}}%
        \renewcommand{\thequestion}{\arabic{question}}%
    \fi%
    }%
%\AfterEndPreamble{\refstepcounter{mys@eval@vers}}
%
%----------% Numérotation de version 
%
%    Initialisations
%
\newcounter{mys@eval@vers}%
\setcounter{mys@eval@vers}{0}%
%
%        Définition du numéro global de l'éval
%
\newcommand\Setversion[1]{%
    \setcounter{mys@eval@vers}{\numexpr#1-1\relax}%
    \refstepcounter{mys@eval@vers}%
    }%
% ou  \newcommand\Setversion[1]{\setcounter{mys@eval@vers}{#1}}} ?
%
%----------% Année 
%
%    Initialisations
%
\let\@nnee\error@nneeindefinie% année de début
\let\@@nnee\error@@nneeindefinie%  année suivante
\let\@annee\error@anneeindefinie% texte à imprimer pour l'année scolaire (année-année+1 par exemple)
%
%    Année de fin = année de début + 1
\def\next@annee{\def\@@nnee{\the\numexpr \@nnee+1\relax}}%
%
%    Définition de l'année de début et calcul de l'année de fin
%
\def\Setannee#1{\def\@nnee{#1}\next@annee}%
%
%    Traitement de la clé
%
\expandafter\Setannee\expandafter{\@eval@annee@first}%
%
%----------% Année scolaire
%
%    Token définissable par l'utilisateur stockant le texte de remplacement pour la macro définissant la présentation de l'année scolaire.
% #1 = année de début
% #2 = année de fin
%
\newtoks\Anneescolairepattern%
%
%    Macro définissant le token \Anneescolairepattern et la macro \@nneeScol@ireBuilder construisant l'année scolaire
%
%    Initialisation de la macro annexe \@nneeScol@ireBuilder
%
\let\@nneeScol@ireBuilder\error@AnneeScolaireBuilder@indefini%
%
%    Définition de l'année scolaire
%
\def\Setanneescolaire#1{%
    \Anneescolairepattern={#1}%
    \expandafter\def\expandafter\@nneeScol@ireBuilder\expandafter##\expandafter1\expandafter##\expandafter2\expandafter{\the\Anneescolairepattern}%
    }%
%
%    Initialisation de la forme de l'année scolaire (tiret entre année de début et année de fin)
%
\Setanneescolaire{#1--#2}% #1= année de début, #2 = année de fin
%
%    Stocke l'année scolaire pour utilisation dans le code
%
\def\@annee{\@nneeScol@ireBuilder\@nnee\@@nnee}%
%
%    Macro d'accès
%
\def\Printanneescolaire{\@annee}%
%
%----------% Classe 
%
%    Token définissable par l'utilisateur stockant le texte de remplacement pour la macro définissant la présentation de la classe.
% #1 = niveau
% #2 = division
% #3 = spécialité
%
\newtoks\Classepattern%
%
%    Macro définissant le token \Classepattern et la macro \Cl@sseBuilder construisant la classe
%
%    Initialisation de la macro annexe \@nneeScol@ireBuilder
%
\let\cl@sseBuilder\error@ClasseBuilder@indefini%
%
%    Définition de la classe
%
\def\Setclassebuilder#1{%
    \Classepattern={#1}%
    \expandafter\def\expandafter\cl@sseBuilder\expandafter##\expandafter1\expandafter##\expandafter2\expandafter##\expandafter3\expandafter{\the\Classepattern}%
    }%
%
%    Initialisation de la forme de la classe
%
\Setclassebuilder{%
    \ifblank{#2}%
        {%
        \mys@objet@niveau%
        \ifblank{#3}{}{\ \mys@objet@specialite}
        }%
        {%
        #1#2\ifblank{#3}{}{\ (\ \mys@objet@specialite)}
        }%
    }%
%
%    Macro d'accès
%
\def\classe{\@classe}%
%
%    Définition de la classe
%
\def\Setclasse#1{%
    \ifblank{#1}%
        {%
        \edef\mys@tmp{{\@eval@niveau}{\@eval@division}{\@eval@specialite}}
        \expandafter\expandafter\expandafter\gdef\expandafter\expandafter\expandafter\@classe\expandafter\expandafter\expandafter{\expandafter\cl@sseBuilder\mys@tmp}
        }%
        {\gdef\@classe{#1}}%
    }%
%
%    Traitement de la clé
%
\expandafter\Setclasse\expandafter{\@eval@classe}%
%
%----------% Spécialité (application à la valeur de la clé)
%
\expandafter\Setspecialite\expandafter{\@eval@specialite}%
%
%----------% Niveau (application à la valeur de la clé)
%
\expandafter\Setniveau\expandafter{\@eval@niveau}%
%
%----------% Matière (application à la valeur de la clé)
%
%    Traitement de la clé
%
\expandafter\Setmatiere\expandafter{\@eval@matiere}%
%
%----------% Genre (application à la valeur de la clé)
%
%    Traitement de la clé
%
\expandafter\Setgenre\expandafter{\@eval@genre}%
%
%----------% Sous-genre (application à la valeur de la clé)
%
%    Traitement de la clé
%
\expandafter\Setsousgenre\expandafter{\@eval@sousgenre}%
%
%----------% 2 pages sur 1
%
%    Traitement de la clé
%
\if@iipagesuri %
    \AddToHook{ begindocument/before}{%
        \geometry{paperheight=148.5mm,bottom=15mm}% a4= 210mm x 297mm
        \pgfpageslogicalpageoptions{1}{border code=\pgfstroke}
        \deuxpagessurune%
    }%
\fi
%
%
%
\if@iipagesurinofiles %
    \AddToHook{ begindocument/before}{%
        \geometry{paperheight=148.5mm,bottom=15mm}% a4= 210mm x 297mm
        \pgfpageslogicalpageoptions{1}{border code=\pgfstroke}
        \deuxpagessurune\nofiles%
    }%
\fi
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Macros diverses
%
%----------% Input permet d'input le bon fichier
%
\ExplSyntaxOn
\newcommand\Input[1]{%
    \if\relax\@eval@sousgenre\relax%
        \input{#1-\str_case:VnTF\@eval@genre{
            {corr}{corr}
            {Corr}{corr}
            {pcorr}{corr}
            {pCorr}{corr}
            }{}{\@eval@genre}}%
    \else%
        \input{#1-\str_case:VnTF\@eval@genre{
            {corr}{corr}
            {Corr}{corr}
            {pcorr}{corr}
            {pCorr}{corr}
            }{}{\@eval@genre}%
            -\str_case:VnTF\@eval@sousgenre{
            {corr}{corr}
            {Corr}{corr}
            {pcorr}{corr}
            {pCorr}{corr}
            }{}{\@eval@sousgenre}%
        }%
    \fi%
    }%
\ExplSyntaxOff
%
%----------% Not For Pap
%
%---------------------------------------------------------------------------------------------------------------------------------------------------
% INTÉRÊT DU COMPTEUR ???
%---------------------------------------------------------------------------------------------------------------------------------------------------
%
%    Initialisation
%
\newcounter{not@for@pap@counter}
\setcounter{not@for@pap@counter}{0}
%
%    Affichage de PAP
%
\newcommand\notforpap[1][PAP]{%
    \stepcounter{not@for@pap@counter}%
    \tikzmark{start-\thenot@for@pap@counter}%
    \tikz[remember picture,overlay,baseline=(sta.base)]{%
        \coordinate(sta) at ( $ (current page.west|-{pic cs:start-\thenot@for@pap@counter}) + %
            (\oddsidemargin+\hoffset+1in,0) $ );%
        \node[anchor=base east](main) at (sta) {\ding{42}};%$\bullet$
        \node[anchor=base east,xshift=-1ex,inner sep=1pt,outer sep=0pt](mot) at (main.base){\textbf{#1}};
        \draw (mot.north east) -- (mot.south west);
        \draw (mot.south east) -- (mot.north west);
        }%
    }%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Réglages divers d'éléments du documents
%
%----------% parindent
%
\setlength{\parindent}{0cm}%
%
%----------% ????
%
\IfFileExists{eval.lastnums}%
    {\input{eval.lastnums}}%
    {%
    \setcounter{mys@eval@count@\@eval@genre}{0}%
    \setcounter{mys@eval@count@eval}{0}%
    }%
%
%
%
\AtBeginDocument{%
    \ifnum\@eval@genre@num=0 %
    \else%
        \setcounter{mys@eval@count@\@eval@genre}{\numexpr\@eval@genre@num-1\relax}
    \fi
    \ifnum\@eval@num=0 %
    \else%
        \setcounter{mys@eval@count@eval}{\numexpr\@eval@num-1\relax}
    \fi
    \refstepcounter{mys@eval@count@\@eval@genre}%
    \refstepcounter{mys@eval@count@eval}%
%    \newwrite\numbersofeval%
%    \immediate\openout\numbersofeval=eval.lastnums%
%    \immediate\write\numbersofeval{\@eval@genre!\jobname!\arabic{mys@eval@count@\@eval@genre}!\arabic{mys@eval@count@eval}!\the\day-\the\month-\the\year!\thedateday-\thedatemonth-\thedateyear\noexpand\@nil}
%    \immediate\write\numbersofeval{%
%%        \jobname\newline
%        \global\string\setcounter{mys@eval@count@\@eval@genre}{\arabic{mys@eval@count@\@eval@genre}}%
%        \global\string\setcounter{mys@eval@count@eval}{\arabic{mys@eval@count@eval}}%
%        }%
%    \immediate\closeout\numbersofeval%
    }% 
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Choix des options par défauts des packages
%
%\input{eval.defauts}%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% définitions des macros \mys@objet@<objet>
%
\def\errorsinondefini#1{\expandafter\ifx\csname @#1@\endcsname\@empty\ERROR Définir la valeur prise par #1\fi }
\foreach \i in \mys@objet@liste@objet{\csname Build@\i\endcsname}
\foreach \i in \mys@objet@liste@objet@defobligatoire{\errorsinondefini{\i}}
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Paquets suivants
%
\RequirePackage{pageeval-titre}% après fontenc
% 
%    \RequirePackage{cleveref}%
%
\RequirePackage{mys-paquets}%
%
\ExplSyntaxOn
\NewDocumentCommand{\mys@tblrcellwidth}{ }{
    \l__tblr_cell_wd_dim
}
\NewDocumentCommand{\MysSetTblrabovesep}{m }{
    \dim_set:Nn\l__tblr_row_abovesep_dim{#1}
}
\NewDocumentCommand{\MysSetTblrbelowsep}{m }{
    \dim_set:Nn\l__tblr_row_belowsep_dim{#1}
}
\ExplSyntaxOff
%
\NewColumnType{N}[1][5ex]{Q[#1,c,m]}
\newcommand{\MoreItems}[3][]{% à n'utiliser que si on met au moins deux items de notations dans la ligne
    \ifx\relax#1\relax %
        \begin{tblr}{%
            width=\mys@tblrcellwidth,%
            column{even}={$,font=\boldmath},%
            column{1}={colsep=0pt},%
            column{Z}={rightsep=0pt},%
            colspec={*{#2-1}{X[c]|N|}X[c]|N}%
            } %
        #3 %
        \end{tblr}%
    \else %
        \begin{tblr}{%
            width=\mys@tblrcellwidth,%
            column{even}={$,font=\boldmath},%
            column{1}={colsep=0pt},%
            column{Z}={rightsep=0pt},%
            colspec={#1}%
            } %
        #3 %
        \end{tblr}%
    \fi %
        }
%
\NewDocumentEnvironment{GrilleEval}{O{}+b}{%
    \begin{tblr}{%
        hlines,vlines,%
        colspec={*{2}{c}NQ[3ex,c]},%
        column{3}={$,font=\boldmath},%
        column{4}={$,cmd=\textcolor{red},font=\boldmath},%
        #1}%
    #2
    \end{tblr}%
}{}%
%
\RequirePackage{mys-environments}%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Test des valeurs de certaines macros
%
%\def\test{%
%    \show\@eval@classe
%    \show\@classe
%%    \show\@eval@specialite
%%    \show\@eval@division
%%    \show\@eval@sousgenre
%    \show\@eval@niveau\show\mys@objet@niveau
%    \show\@eval@date
%    \show\@eval@duree
%    \show\@eval@matiere
%    \show\@eval@genre
%    \show\@eval@bareme
%    \show\@eval@contenu
%    \show\@eval@chemin
%    \show\@eval@genre@num
%    \show\@eval@num
%}
%%
%\test
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Voir
% Dans le préambule ou avec les clés définies dans eval.cls :
%
%\Setannee{2018}%
% 
%\Setniveau{1}% 1, t 
%\SetNiveau{1\textsuperscript{t2}\it{S}}% Ca marche aussi !
%
%\Setmatiere{m}% info 
%
%\Setgenre{c}% activité, exercices, ...
%
%\Setsousgenre{corr}
%
% Dans le préambule ou dans le corps du document :
%
%\Setanneescolaire{$#1**#2$}
%\Setanneescolaire{$#1++#2$}
%
% Dans le corps du document :
%
%\Printanneescolaire