% !TEX encoding = UTF-8
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
\NeedsTeXFormat{LaTeX2e}[2019/06/13]%
%
\ProvidesClass{cours}%
%
\RequirePackage{pgfopts}%
%
\RequirePackage{scrlfile}% pour \AfterClass
%
\RequirePackage{mys-input-path}%
%
\@ifpackageloaded{xpatch}% Pour \xpretocmd
    {\typeout{Essai de chargement multiple du package xpatch.}}%
    {\RequirePackage{xpatch}}
%
\@ifpackageloaded{comment}%
    {\typeout{Essai de chargement multiple du package comment.}}%
    {\RequirePackage{comment}}
%
%\@ifpackageloaded{titlesec}%
%    {\typeout{Essai de chargement multiple du package titlesec.}}%
%    {\RequirePackage{titlesec}}
%%
%\titleformat{\chapter}[display]
%{\normalfont\huge\bfseries}{\chaptertitlename\ \thechapter}{20pt}{\Huge}
%\titleformat{\section}
%{\normalfont\Large\bfseries}{\thesection}{1em}{}
%\titleformat{\subsection}
%{\normalfont\large\bfseries}{\thesubsection}{1em}{}
%\titleformat{\subsubsection}
%{\normalfont\normalsize\bfseries}{\thesubsubsection}{1em}{}
%\titleformat{\paragraph}[runin]
%{\normalfont\normalsize\bfseries}{\theparagraph}{1em}{}
%\titleformat{\subparagraph}[runin]
%{\normalfont\normalsize\bfseries}{\thesubparagraph}{1em}{}
%\titlespacing*{\chapter} {0pt}{50pt}{40pt}
%\titlespacing*{\section} {0pt}{3.5ex plus 1ex minus .2ex}{2.3ex plus .2ex}
%\titlespacing*{\subsection} {0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
%\titlespacing*{\subsubsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}
%\titlespacing*{\paragraph} {0pt}{3.25ex plus 1ex minus .2ex}{1em}
%\titlespacing*{\subparagraph} {\parindent}{3.25ex plus 1ex minus .2ex}{1em}
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%  Initialisation des macros stockant les options de la classe (pour les clés qui ne peuvent avoir aucune valeur). Pour les clés qui doivent être appelées et avec une valeur (non vide), les macros les stockant ne doivent pas être initialisées (pour lever une erreur en cas d'oubli d'appel ou si la valeur donnée est vide).
%
\def\@cours@annee@first{}%
\def\@cours@classe{}%
\def\@cours@niveau{}%
\def\@cours@specialite{}%
\def\@cours@division{}%
\def\@cours@matiere{}%
\def\@cours@genre@liste{}%
\def\@cours@sousgenre@at{}%
\def\@cours@partie@nom{}%
\def\@cours@partie@titre{}%
\def\@cours@partie@num{}%
\def\@cours@chapitre@nom{}%
\def\@cours@chapitre@nom@coul{}%
\def\@cours@chapitre@titre{}%
\def\@cours@chapitre@num{}%
\def\@cours@chapitre@num@coul{}%
\def\@cours@chemin{}%
%\def\@cours@chemin@graphique{}%
\def\@cours@exclure@liste{}%
\def\@cours@inclure@liste{}%
%
% Déclaration de booléen
%
\newif\if@cours@src@recursive%
\newif\if@genre@showed%
\newif\if@sousgenre@showed%
\newif\if@page@pleine%
\newif\if@part@nom@showed
\newif\if@part@titre@showed%
\newif\if@part@deconum@showed%
\newif\if@part@valnum@showed%
\newif\if@chap@nom@showed%
\newif\if@chap@titre@showed%
\newif\if@chap@deconum@showed%
\newif\if@chap@valnum@showed%
\newif\if@exr@onebyone%
\newif\if@iipagesuri%
\newif\if@iipagesurinofiles%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Macros utiles lors de la déclaration des clés
%
% Calcul de l'année de début de l'année scolaire courante au moment de la compilation
%
\def\scolaire@anneei{\ifnum \month> 8 \relax\the\year\else\number\numexpr\year-1\relax\fi}%
%
%
\ExplSyntaxOn
%
\NewDocumentCommand{\exclure}{m}%
    {\exp_args:No\clist_map_inline:nn {#1}{\excludecomment{##1}}}
%
\NewDocumentCommand{\inclure}{m}%
    {\clist_map_inline:nn {#1}{\includecomment{##1}}}
%
\ExplSyntaxOff
%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Définition des options globales par défaut
%
\def\cours@classoptions{10pt,a4paper,french}%,oneside,onecolumn
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Définitions des clés
%
\pgfkeys{%
    /cours/.cd,%
%
%  construction récursive ou non des noms de fichiers inclus
%
    recursif/.is if = @cours@src@recursive,%
    nested-src/.style={recursif=true},%
%
%  exclure ou inclure des environnements
%
    exclure/.store in = \@cours@exclure@liste,%
    inclure/.store in = \@cours@inclure@liste,%
%
%----------% Le fichier contenant le nombre de parties du document est supprimé
%
    clearnumofparts/.code = {\input{|"rm ./\jobname.numofparts"}},%{|"/usr/local/bin/my-shell-script.sh"}
%
%----------% Année 
%
    annee/.store in=\@cours@annee@first,%
    annee/.default=\scolaire@anneei,%
%
%----------% Classe
%
    classe/.store in=\@cours@classe,% classe l'emporte sur niveau
%
%----------% Niveau
%
    niveau/.store in=\@cours@niveau,%
    niveau/.value required,%
%
%----------% Spécialité 
%
    specialite/.store in=\@cours@specialite,%
%
%----------% Division 
%
    division/.store in=\@cours@division,%
%
%----------% Matière 
%
    matiere/.store in=\@cours@matiere,%
    matiere/.value required,%
%
%----------% Genre 
%
    genre/.store in = \@cours@genre@liste,%
    genre/.value required,%
%
    if_affiche_genre/.is if = @genre@showed,%
%
    sans-genre/.style = {if_affiche_genre=false},%
%
%----------% Sous-genre at
%
    sousgenre-at/.store in=\@cours@sousgenre@at,%
    sousgenre-at/.initial = south,%
    sousgenre-at/.default =south,%
%
%----------% Sous-genre 
%
    sous_genre/.store in = \@cours@sousgenre,%
    sous_genre/.value required,%
%
    if_affiche_sousgenre/.is if = @sousgenre@showed,%
%
    sans-sousgenre/.style = {if_affiche_sousgenre=false},%
%
    sousgenre/.style={sous_genre={#1},sousgenre-at={south}},% south à éviter si #1 est vide ou blanc    
%%
%%----------% Sous-sous-genre 
%%
%    soussous_genre/.store in = \@cours@soussousgenre,%
%    soussous_genre/.value required,%
%%
%    if_affiche_soussousgenre/.is if = @soussousgenre@showed,%
%%
%    sans-soussousgenre/.style = {if_affiche_soussousgenre=false},%
%%
%    soussousgenre/.style={soussous_genre={#1},soussousgenre-at={west}},% south à éviter si #1 est vide ou blanc    
%
%----------% Chemin des sources des chapitres
%
    chemin/.store in = \@cours@chemin,
%
%----------% Chemin des images
%
%    chemin-graph/.store in = \@cours@chemin@graphique,%
    chemin-graph/.code={\ifblank{#1}{}{\AfterClass{cours}{\graphicspath{#1}}\fi}},%
%
%----------% Page pleine 
%
    page-pleine/.is if=@page@pleine,%
    page-pleine/.initial=false,%
    page-pleine/.default=true,%
%
%----------%----------% PARTIE
%
%----------% Nom de la partie (partie ou autre) :
%
    if_partie_nom/.is if = @part@nom@showed,%
%
    partie_nom/.store in = \@cours@partie@nom,%
    partie_nom/.initial = Partie,%
    partie_nom/.default = Partie,%
%
    partie-nom/.style = {partie_nom=#1,if_partie_nom=true},%
    partie-nom/.value required,%
%
    sans-partie-nom/.style = {if_partie_nom=false},%
%
%----------% Titre de la partie :
%
    if_partie_titre/.is if = @part@titre@showed,%
%
    partie_titre/.store in = \@cours@partie@titre,%
    partie_titre/.value required,%
%
    partie-titre/.style = {partie_titre=#1,if_partie_titre=true},%
    partie-titre/.value required,%
%
    sans-partie-titre/.style = {if_partie_titre=false},%
%
%----------% Décoration du numéro de la partie :
%
    if_partie_deconum/.is if = @part@deconum@showed,% cadre du numéro de partie
%
    sans-partie-deconum/.style = {if_partie_deconum=false},%
%
%----------% Numéro de la partie :
%
    if_partie_valnum/.is if = @part@valnum@showed,% numéro de la partie 
%
    sans-partie-valnum/.style = {if_partie_valnum=false,if_partie_deconum=true},%
%
    partie_num/.store in = \@cours@partie@num,%
    partie_num/.value required,%
%
    partie-num/.style = {partie_num=#1,if_partie_valnum=true,if_partie_deconum=true},%
    partie-num/.value required,%
%
    partie-autonum-id/.store in = \@cours@partie@autonum@id,%
    partie-autonum-id/.initial = \@cours@niveau\@cours@division,%
    partie-autonum-id/.default = \@cours@niveau\@cours@division,%
%
    sans-partie-num/.style = {if_partie_valnum=false,if_partie_deconum=false},%
%
%
    sans-partie/.style={sans-partie-num,sans-partie-nom,sans-partie-deconum},%
%
%----------%----------% CHAPITRE
%
%----------% Nom du chapitre (chapitre ou autre) :
%
    if_chapitre_nom/.is if = @chap@nom@showed,%
%
    chapitre_nom/.store in = \@cours@chapitre@nom,%
    chapitre_nom/.initial = Chapitre,%
    chapitre_nom/.default = Chapitre,%
%
    chapitre-nom/.style = {chapitre_nom=#1,if_chapitre_nom=true},%
    chapitre-nom/.value required,%
%
    sans-chapitre-nom/.style = {if_chapitre_nom=false},%
%
    chapitre-nom-couleur/.store in = \@cours@chapitre@nom@coul,%
    chapitre-nom-couleur/.initial = black,%
    chapitre-nom-couleur/.default = black,%
%
%----------% Titre du chapitre :
%
    if_chapitre_titre/.is if = @chap@titre@showed,%
%
    chapitre_titre/.store in = \@cours@chapitre@titre,%
    chapitre_titre/.value required,%
%
    chapitre-titre/.style = {chapitre_titre=#1},%
    chapitre-titre/.value required,%
%
    sans-chapitre-titre/.style = {if_chapitre_titre=false},%
%
%----------% Décoration du numéro du chapitre :
%
    if_chapitre_deconum/.is if = @chap@deconum@showed,% cadre du numéro de partie
%
    sans-chapitre-deconum/.style = {if_chapitre_deconum=false},%
%
%----------% Numéro du chapitre :
%
    if_chapitre_valnum/.is if = @chap@valnum@showed,% numéro de la partie 
%
    sans-chapitre-valnum/.style = {if_chapitre_valnum=false},%
%
    chapitre_num/.store in = \@cours@chapitre@num,%
    chapitre_num/.value required,%
%
    chapitre-num/.style = {chapitre_num=#1,if_chapitre_valnum=true,if_chapitre_deconum=true},%
    chapitre-num/.value required,%
%
    sans-chapitre-num/.style = {if_chapitre_valnum=false,if_chapitre_deconum=false},%
%
    sans-chapitre/.style={sans-chapitre-nom,sans-chapitre-num},%
%
%
    chapitre-unique/.style = {sans-chapitre-num,if_chapitre_nom=false,sans-partie-titre},%
%
    chapitre-num-couleur/.store in = \@cours@chapitre@num@coul,%
    chapitre-num-couleur/.initial = white,%
    chapitre-num-couleur/.default = white,%
%
%----------%----------% 1 BY 1
%
    1by1/.is if = @exr@onebyone,%
    1by1/.default=true,%
%
%----------% 2 pages sur 1
%
    2pagessur1/.is choice,%
    2pagessur1/1/.is if = @iipagesurinofiles,%
    2pagessur1/1/.default = true,%
    2pagessur1/2/.is if = @iipagesuri,%
    2pagessur1/2/.default = true,%
%
%----------% Aliases 
%
    cours/.style={genre=c},%
    activite/.style={genre=c},%
    massicot/.style={genre=#1,page-pleine},%
    corr/.style={sousgenre=corr},%
    sans-titre/.style = {if_chapitre_titre=false},%
    avec-titre/.style = {if_chapitre_titre=true},%
%
%----------% Clés inconnues 
%
    .unknown/.code={\edef\cours@classoptions{\cours@classoptions,\pgfkeyscurrentname}},%
%    .unknown/.code={\edef\cours@articleoptions{\cours@articleoptions,\pgfkeyscurrentname}},%
    }%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Valeurs par défaut de clés
%
\pgfkeys{%
    /cours/.cd,%
    recursif=false,%
    annee,% si la clé annee n'est pas appelée ... elle le sera quand même :)
    if_partie_nom=true,%
    if_partie_titre=true,%
    if_partie_deconum=true,%
    if_partie_valnum=true,%
    if_chapitre_nom=true,%
    if_chapitre_titre=true,% pourquoi est-ce nécessaire ? si ce code est absent, la valeur utilisée de if_titre est false même si sans-titre n'est pas appelé
    if_chapitre_deconum=true,%
    if_chapitre_valnum=true,%
    chapitre-num-couleur=white,%
    chapitre-nom-couleur=black,%
    chapitre_nom,%
    partie_nom,%
    partie-autonum-id,%
    if_affiche_genre=true,%
    if_affiche_sousgenre=true,%
    sousgenre-at,% utile ?
    sous_genre={},% utile?
    matiere=m,%
    1by1=false,%
    2pagessur1/1=false,%
    2pagessur1/2=false,%
    partie-num=-1,%
    }
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Acquisition des valeurs des clés (?)
%
\ProcessPgfOptions{/cours}%
%
\edef\@classoptionslist{\cours@classoptions}
%
\LoadClass[\@classoptionslist]{article}
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%---------------------------------------------------------------------------------------------------------------------------------------------------
% PROBLÈME :
%    \RequirePackage{mys-objet} doit être après \ProcessPgfOptions{/cours} sinon :
%            \cours@niveau (ou la macro de stockage correspondante pour toute clé dont la valeur est donnée
%            en option lors de \documentclass[ ... ]{cours})  est vide (la valeur saisie en option n'est pas
%            stockée dans la macro). 
%    POURQUOI ???
%---------------------------------------------------------------------------------------------------------------------------------------------------
%%
\RequirePackage{mys-objet}%
%%
\input{mys-objet-cours-setup.tex}%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Interfaces
%
%----------% Interface de définition des options de la classe
%
\newcommand*{\SetCours}[1]{\pgfqkeys{/cours}{#1}}%
%
%----------% Interface de clearnumofparts
%
\newcommand\resetnumofparts{\pgfkeys{/cours/clearnumofparts}}%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Traitement des valeurs des clés et interfaces
%
%----------% exclure, inclure
%
\expandafter\ifblank\expandafter{\@cours@exclure@liste}%
    {}%
    {\AtBeginDocument{\exclure{\@cours@exclure@liste}}}%
%
%
%
\expandafter\ifblank\expandafter{\@cours@inclure@liste}%
    {}%
    {\AtBeginDocument{\inclure{\@cours@inclure@liste}}}%
%
%----------% Nom de la partie (en général c'est "Partie" mais ça peut être autre chose)
%
%    Définition du nom de partie
%
\def\mypartname{Partie}%
\newcommand\Setpartname[1]{\renewcommand\mypartname{#1}}%
%
%    Traitement de la clé
%
\expandafter\Setpartname\expandafter{\@cours@partie@nom}%
%
%----------% Nom du chapitre  (en général c'est "Chapitre" mais ça peut être autre chose)
%
\newcommand\chaptername{Chapitre}%
%
%    Définition du nom de chapitre
%
\newcommand\Setchaptername[1]{\renewcommand\chaptername{#1}}%
%
%    Traitement de la clé
%
\expandafter\Setchaptername\expandafter{\@cours@chapitre@nom}%
%
%----------% Titre du chapitre
%
%    Définition du titre de chapitre
%
\newcommand\Setchaptertitle[1]{\title{#1}}
%
%    Traitement de la clé
%
\expandafter\ifblank\expandafter{\@cours@chapitre@titre}%
    {}%
    {\AfterClass{cours}{\expandafter\Setchaptertitle\expandafter{\@cours@chapitre@titre}}}%
%
%----------% Chemin des sources des chapitres 
%
%    Définition du chemin
%
\newcommand\Setchemin[1]{\mys@fichier@path{#1}}%
%
%    Traitement de la clé
%
\expandafter\ifblank\expandafter{\@cours@chemin}%
    {}%
    {\AfterClass{cours}{\expandafter\Setchemin\expandafter{\@cours@chemin}}}%
%
%----------% Définition du chemin des graphiques
%
%\ifx\relax\@cours@chemin@graphique\relax\else\show\@cours@chemin@graphique\AfterClass{cours}{\graphicspath{\@cours@chemin@graphique}}\fi
%
%----------% Page pleine
%
%    Traitement de la clé
%
\if@page@pleine \AfterEndPreamble{\renewcommand\maketitle{\pagepleine}}\fi%
%
%----------% Numéro de chapitre 
%
%    Initialisations
%
\newcounter{@num@chap}%
\setcounter{@num@chap}{-1}%
%
%    Définition du numéro de chapitre
%
\newcommand\Setnumchap[1]{%
    \setcounter{@num@chap}{\numexpr#1-1\relax}%
    \refstepcounter{@num@chap}%
    }% utiliser cette définition plutôt que \def\Setnumchap#1{\setcounter{@num@chap}{#1}} pour que la réinitialisation des compteurs des environnements au niveau du numéro de chapitre fonctionnent : si on intercale \Setnumchap{numéro que l'on veut} entre deux définitions, la dernière est réinitialisée.
%
%    Traitement de la clé
%
%\if@chap@valnum@showed
\expandafter\Setnumchap\expandafter{\@cours@chapitre@num}%
%\fi
%
%----------% Numéro de partie 
%
%    Initialisations
%
\newcounter{@num@part}
\setcounter{@num@part}{-1}
%
%    Définition du numéro de partie
%
\newcommand\Setnumpart[1]{%
    \setcounter{@num@part}{\numexpr#1-1\relax}%
    \refstepcounter{@num@part}%
    }%
% Pourquoi pas : \newcommand\Setnumpart[1]{\setcounter{@num@part}{#1}} ?
%
%    Traitement de la clé
%
%\if@part@valnum@showed
\ifnum\@cours@partie@num<0\relax \def\@cours@partie@num{\csname mys@\@cours@partie@autonum@id @partie@\@cours@partie@titre @num\endcsname}\fi%
%
\expandafter\Setnumpart\expandafter{\@cours@partie@num}%
%\fi
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
\expandafter\Setannee\expandafter{\@cours@annee@first}%
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
        \ifblank{#3}{}{\ (\mys@objet@specialite)}
        }%
        {%
        \ifx#1t T\else#1\fi%
        #2\ifblank{#3}{}{\ (\mys@objet@specialite)}
        }%
    }
%    
%\Setclassebuilder{%
%    \ifx\relax#2\relax\mys@objet@niveau%
%        \ifx\relax#3\relax\else\  \mys@objet@specialite\fi
%    \else#1#2%
%        \ifx\relax#3\relax\else \ (\ \mys@objet@specialite)\fi
%    \fi}%
%
%    Macro d'accès
%
\def\classe{\@classe}%
%
%    Définition de la classe
%
\def\Setclasse#1{%
%\show\mys@objet@niveau
    \ifblank{#1}% 
        {%
        \edef\mys@tmp{{\@cours@niveau}{\@cours@division}{\@cours@specialite}}
        \expandafter\expandafter\expandafter\gdef\expandafter\expandafter\expandafter\@classe\expandafter\expandafter\expandafter{\expandafter\cl@sseBuilder\mys@tmp}
%        \show\@classe
        }%
        {\gdef\@classe{#1}}%
    }%
%
%\def\Setclasse#1{%
%    \ifx\relax#1\relax 
%        \edef\mys@tmp{{\@cours@niveau}{\@cours@division}{\@cours@specialite}}
%        \expandafter\expandafter\expandafter\gdef\expandafter\expandafter\expandafter\@classe\expandafter\expandafter\expandafter{\expandafter\cl@sseBuilder\mys@tmp}
%    \else%
%        \gdef\@classe{#1}
%    \fi%
%    }%
%
%    Traitement de la clé
%
%\expandafter\Setclasse\expandafter{\@cours@classe}%
\expandafter\Setclasse\expandafter{}%
%
%----------% Spécialité (application à la valeur de la clé)
%
\expandafter\Setspecialite\expandafter{\@cours@specialite}%
%
%----------% Niveau (application à la valeur de la clé)
%
\expandafter\Setniveau\expandafter{\@cours@niveau}%
%
%----------% Titre de la partie (application à la valeur de la clé)
%
%    Définition du titre de partie
%
\expandafter\Setpartie\expandafter{\@cours@partie@titre}%
%
%    Traitement de la clé
%
%\expandafter\ifblank\expandafter{\@cours@partie@titre}%
%    {}%
%    {\AfterClass{cours}{\expandafter\Setpartie\expandafter{\@cours@partie@titre}}}%
%
%----------% Matière (application à la valeur de la clé)
%
%    Traitement de la clé
%
\expandafter\Setmatiere\expandafter{\@cours@matiere}%
%
%----------% Genre, sous-genre et sous-sous-genre
%
%----    Initialisation des macros de stockage des valeurs
%
\def\@cours@genre{}%
%\def\@cours@sousgenre{}% sinon cela remplace la valeur passée à la clé par l'utilisateur !!!!
\def\@cours@soussousgenre{}%
%
%
%
\def\@cours@parse@genre#1{\@cours@get@genre@primaire#1-\mys@macro@fin}
%
%----    Partie primaire du genre
%
\def\@cours@get@genre@primaire#1-#2\mys@macro@fin{%
    \gdef\@cours@genre{#1}% \gdef ou \def ?
    \ifblank{#2}{}{\@cours@get@genre@secondaire#2\mys@macro@fin}%
    }%
%
%----    Parties secondaires et tertiaires du genre
%
\def\@cours@get@genre@secondaire#1-#2\mys@macro@fin{%
    \gdef\@cours@sousgenre{#1}% ou \gdef ou \def ?
    \ifblank{#2}{}{\xdef\@cours@soussousgenre{\@cours@genre@supptiret@#2}}% ou \gdef ou \def ?
    }
%
%---- Helper Macro : suppression du dernier tiret
%    
\def\@cours@genre@supptiret@#1-{#1}
%
%---- Traitement de la clé
%
\expandafter\@cours@parse@genre\expandafter{\@cours@genre@liste}
%
%----------% Genre (application à la valeur de la clé)
%
\expandafter\Setgenre\expandafter{\@cours@genre}%
%
%----------% Sous-genre (application à la valeur de la clé)
%
%    Traitement de la clé
%
\expandafter\Setsousgenre\expandafter{\@cours@sousgenre}%
%
% Inutile si on créé les sources ...-c-comp.tex et ...-c-ess.tex
%\def\testess{ess}
%\def\testcomp{comp}
%\ifx\@cours@sousgenre\testess \AtBeginDocument{\exclure{\listeenvcomplements}}\fi
%\ifx\@cours@sousgenre\testcomp \AtBeginDocument{\exclure{\listeenvessentiel}}\fi
%
%----------% Sous-sous-genre (application à la valeur de la clé)
%
%    Traitement de la clé
%
\expandafter\Setsoussousgenre\expandafter{\@cours@soussousgenre}%
%
%----------% 1by1
%
%    Traitement de la clé
%
\if@exr@onebyone \AtEndPreamble{\Setexr{newpage}\Setact{newpage}}\fi
%
%----------% n pages sur 1
%
%    Traitement de la clé
%
\if@iipagesuri %
%    \AddToHook{ begindocument/before}{%
    \AtBeginDocument{%
%        \geometry{paperheight=148.5mm,bottom=15mm}% a4= 210mm x 297mm
%        \pgfpageslogicalpageoptions{1}{border code=\pgfstroke}
        \deuxpagessurune%
    }%
\fi
%
%
%
\if@iipagesurinofiles %
%    \AddToHook{ begindocument/before}{%
    \AtBeginDocument{%
%        \geometry{paperheight=148.5mm,bottom=15mm}% a4= 210mm x 297mm
%        \pgfpageslogicalpageoptions{1}{border code=\pgfstroke}
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
\def\mys@cours@file@to@input@nivi#1{%
    \if@cours@src@recursive%
        \edef\@cours@file@to@input{#1-\@cours@genre}%
    \else%
        \expandafter\ifblank\expandafter{\@cours@sousgenre}%
            {\edef\@cours@file@to@input{#1-\@cours@genre}}%
            {\edef\@cours@file@to@input{#1-\@cours@genre-\@cours@sousgenre}}%
    \fi%
    }%
%
%
%
\def\mys@cours@file@to@input@nivii#1{%
    \expandafter\ifblank\expandafter{\@cours@sousgenre}%
        {\edef\@cours@file@to@input{\@cours@file@to@input@i #1-\@cours@genre}}%
        {\edef\@cours@file@to@input{\@cours@file@to@input@i #1-\@cours@genre-\@cours@sousgenre}}%
    }%
%
%
%
\def\mys@cours@file@to@input@niviii#1{%
    \expandafter\ifblank\expandafter{\@cours@soussousgenre}%
        {\edef\@cours@file@to@input{\@cours@file@to@input@ii#1}}%
        {\edef\@cours@file@to@input{\@cours@file@to@input@ii#1-\@cours@soussousgenre}}%
    }%
%
% Pour que le code soit pertinent :
%    soit on \input les fichiers dont les noms sont construits à partir du genre et du sous-genre (l'option recursif ne doit pas être utilisée)
%    soit on \input en premier un fichier qui lui-même \input les fichiers utiles (pour le premier fichier on utilise l'option recursif pour ne pas utiliser le sous-genre dans la construction du nom de fichier par contre pour les autres fichiers on utilise le genre et le sous-genre dans la construction du nom de fichier).
%
%----------------------------------------------------------
%
% Exemple 1 :
%    Dans le fichier source : \Input{trucmuche-c-ess}, \Input{trucmache-c-ess}, \Input{trucmoche-c-ess} ...
%    On compile avec les options "genre=c-ess"
%
% Exemple 2 : 
%    Dans le fichier source : \Input{truc} 
%    Dans le fichier truc-c.tex : \Input{trucmuche}, \Input{trucmache}, \Input{trucmoche} ...
%    On compile avec les options "genre=c-ess,nested-src"
%
%----------------------------------------------------------
%
\def\@cours@genre@act{a}
\def\@cours@genre@cours{c}
\def\@cours@genre@exr{e}
\def\@cours@genre@mth{mth}
\def\@cours@sousgenre@mth{mth}
\def\@cours@file@to@input{}
\def\@cours@file@to@input@i{}
\def\@cours@file@to@input@ii{}
%
\newcounter{currentinputlevel}
%
\newcommand\Input[1]{%
    \addtocounter{currentinputlevel}{1}%
    \ifnum\value{currentinputlevel}=1% input level = 1
        \mys@cours@file@to@input@nivi{#1}%
    \else% ce n'est pas le premier \Input alors la construction du nom du fichier à inclure utilise le genre et le sous-genre (ou le sous-genre et le sous-sous-genre)
        \ifnum\value{currentinputlevel}=3% Cas utile ?
%            \ifx\@cours@sousgenre\@cours@sousgenre@mth%
%                \edef\@cours@file@to@input@ii{\@cours@file@to@input@i mth/}%
%            \fi%
            \mys@cours@file@to@input@niviii{#1}%
        \else% input level = 2
            \ifx\@cours@genre\@cours@genre@cours%
                \def\@cours@file@to@input@i{crs/}%
            \else%
                \ifx\@cours@genre\@cours@genre@exr%
                    \def\@cours@file@to@input@i{exr/}%
                \else%
                    \ifx\@cours@genre\@cours@genre@act\def\@cours@file@to@input@i{act/}%
                    \else%
                        \ifx\@cours@genre\@cours@genre@mth\def\@cours@file@to@input@i{mth/}\fi%
                    \fi%
                \fi%
            \fi%
            \mys@cours@file@to@input@nivii{#1}%
        \fi%
    \fi%
%    \show\@cours@genre
%    \show\@cours@sousgenre
%    \show\@cours@file@to@input
    \input{\@cours@file@to@input}%
    \vskip-\lastskip\nobreak%
    \addtocounter{currentinputlevel}{-1}%
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
%----------% Définition des labels des sections, sous sections, sous sous sections de telle sorte que :
%    le label de la partie n'est pas inclus dans les labels des sections inférieures lorsqu'il y a 0 ou 1 partie
%    S'il y a au moins 2 parties, les numéros de section, subsection et subsubsection l'indiquent.
%
%    Initialisation de la macro
%
\def\courscls@num@fparts{0}%
%
%    Lecture du fichier donc de la définition de \courscls@num@fparts
%
\IfFileExists{\jobname.numofparts}%
    {\input\jobname.numofparts}%
    {}%
%
%    Ajout à la section \part de l'écriture dans le fichier auxiliaire dédié du nombre de parties rencontré dans le document
%
\xpretocmd{\part}{%
    \ifnum\courscls@num@fparts=0%
        \ifnum \c@part>0%
            \AtEndDocument{%
                \newwrite\numbersofparts%
                \immediate\openout\numbersofparts=\jobname.numofparts%
                \immediate\write\numbersofparts{\global\string\def\string\courscls@num@fparts{1}}%
                \immediate\closeout\numbersofparts%
            }%
        \fi%
    \fi%
    }{}{}% 
%
%    Définitions des labels
%
\renewcommand*{\thepart}{\Alph{part}}%
\renewcommand*{\thesection}{\ifnum\courscls@num@fparts=1\thepart.\fi\Roman{section}}%
\renewcommand*{\thesubsection}{\thesection.\arabic{subsection}}%
\renewcommand*{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}%
%
\@addtoreset{section}{part}%
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Choix des options par défauts des packages
%
%\input{cours.defauts}%
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
\RequirePackage{pagenoneval-titre}% après fontenc
% 
%    \RequirePackage{cleveref}%
%
\RequirePackage{mys-paquets}%
%
\RequirePackage{mys-environments}%
\def\automatisme{}
\newcounter{mysauto}
\setcounter{mysauto}{0}
\@addtoreset{exr}{mysauto}
%
\def\automatismes#1#2{%
    \cuthere%
    \vskip 3pt%
    \foreach \i in {1,...,#1}%
        {%
        \hrule%
        \refstepcounter{mysauto}%
        \vskip 10pt%
        {\bfseries Automatismes \no \themysauto}\Input{#2-\themysauto}%
        \vskip 10pt%
        \hrule%
        \vskip 3pt%
        \cuthere%
        \vskip 3pt%
        }
        }
%
\def\automatisme#1#2{%
    \cuthere%
    \vskip 3pt%
    \hrule%
    \setcounter{mysauto}{#1}
    \vskip 10pt%
    {\bfseries Automatismes \no \themysauto}\Input{#2-\themysauto}%
    \vskip 10pt%
    \hrule%
    \vskip 3pt%
    \cuthere%
    \vskip 3pt%
        }
\def\automatismerep#1#2#3{%
    \setcounter{mysauto}{#2}%
    \foreach \i in {1,...,#1}{%
    \setcounter{exr}{0}%
    \cuthere%
    \vskip 3pt%
    \hrule%
    \vskip 10pt%
    {\bfseries Automatismes \no \themysauto}\Input{#3-\themysauto}%
    \vskip 10pt%
    \hrule%
    \vskip 3pt%
        }%
        \cuthere%
    }
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Test des valeurs de certaines macros
%
\def\test{%
    \show\@cours@classe
    \show\@classe
%    \show\@cours@specialite
%    \show\@cours@division
%    \show\@cours@sousgenre
    \show\@cours@niveau\show\mys@objet@niveau
    \show\@cours@matiere
    \show\@cours@genre
    \show\@cours@sousgenre@at
    \show\@cours@partie@nom
    \show\@cours@partie@titre
    \show\@cours@partie@num
    \show\@cours@chapitre@nom
    \show\@cours@chapitre@nom@coul
    \show\@cours@chapitre@titre
    \show\@cours@chapitre@num
    \show\@cours@chapitre@num@coul
    \show\@cours@chemin
}
%
%\test
%
%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%----------%
%
%% Voir
% Dans le préambule ou avec les clés définies dans cours.cls :
%
%\Setannee{2018}%
% 
%\Setniveau{1}% 1, t 
%\SetNiveau{1\textsuperscript{t2}\it{S}}% Ca marche aussi !
%
%\Setmatiere{m}% info 
%
%\Setnumpart{4}
%
%\Setpartie{al}% info 
%
%\Setnumchap{10}
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