# Symbolic-regression
Multivariate interpretable symbolic regression models generator

<h1>MVR Composer readme</h1>
<p>MVR generates and selects non-linear regression models. It was written in the Matlab language and intended to be used as an open-source code.
</p>
<h2>Introduction</h2>
<p>This software is intended as a curve-fitting tool. The models (curves) are generated using the set of primitive functions.
<!-- More information on the algorithms could be found in <a href="http://strijov.com/papers/strijov08cnrs.pdf">the presentation</a>,
and in <a href="http://strijov.com/papers/strijov06poisk_jct_en.pdf">the paper</a>. The complete documentation in English is coming.
The applications are biology, physics, ecology, economics, etc.  -->
</p><p>
Mathematical modeling has two issues:
first, to create a model of a dynamic system using knowledge
and second, to discover a  model and knowledge using the measured data.
So there are the model-driven and the data-driven approaches,
and each one has its own strengths and weaknesses.
The first one gives models that could be interpreted by experts in a field of application but
usually, they have poor prediction quality.
The second one gives models of good quality but often too complex and non-interpretable by experts.
The suggested approach gathers strong sides of these
two:
the result the  model could be explained and it relies on the measured
data.
It allows getting the model with fair quality and generalization ability in comparison to universal models.
</p><p>
A model is selected from an inductively generated set of the trial models
according to the notion of adequacy: the model must be simple,
stable and precise. These criterions are target functions and they
are assigned according to given data. It is supposed that given
data carries the information on the searched model and the noise
as well. The hypothesis of the probability distribution function
defines a data generation hypothesis and as follows, the target
functions.
</p><p>
The outline of the automatic model creation is the following. A
sample data, which consist of several independent variables and
one dependent variable are given. Experts makes set of terminal
function. These models are arbitrary superposition, inductively
generated using terminal functions.
Experts could also make initial models for inductive modification.
When generated models are tuned, a model of the optimal structure is
selected.
</p><p>
Thus, the result is the non-linear regression model of the optimal structure and
<ul><li>model as a formula, the symbolic description to be used in further research and publication
</li><li> vector of the model parameters, to be used in forecasting
</li><li> plot of the model is .png of in .eps for TeX publications. 
</li></ul>
</p>
<h2>Run demo project</h2>
<p>To watch the MVR demo you must run <code>main.m</code>&nbsp;&#151; demo project. 
There are  three examples:</p>
<pre>
main('demo.prj.txt') <code>two-variate </code>
main('sinc.prj.txt') <code>one-variate regression</code>
main('options.prj.txt') <code>stock-market options (Brent Crude Oil) modelling</code>
</pre>

<h2>Make your own project</h2>
<p>To make your own project you have to do the following.</p>
<ol>
<li>Make data file <code>"filename.dat.txt"</code> with the content
<pre><code>
y, x1, x2, ..., xn
...
y, x1, x2, ..., xn
</code></pre>
see for example <code>"demo.dat.txt"</code> or <code>"sinc.dat.txt"</code>.
</li><li>Make registry file <code>"filename.dat.txt"</code> with the content
<pre><code>
function_, n, m, [opt initial parameters], [domain]
</code></pre>
<code>n</code> is the number of the arguments of the function,
<code>m</code> is the number of the parameters of the function.
The initial parameters so that the function should be identity, if possible, for example
<pre><code>
parabola_ 1, 3, [0 1 0], []  % y = w(1) + w(2)*x + w(3)*x.^2;
</code></pre>
See more examples in <code>"demo.reg.txt"</code>. 
The file <code>"function_.m"</code> must be placed in the folder <code>"mvr\func\"</code> with the content
<pre><code>
function y=function_(w,x)
y = w(1)*x;
</code></pre>
See more examples in this folder, and note the main rules:
    <ul><li> no matter what shape x has, scalar, vector or matrix, y must be of the same shape.
        </li><li> use parameter vector <code>w</code> as a set of scalars say, <code>w(1), ..., w(k)</code>. See the example above.
        </li><li> function names are <code>"function[number of arguments][a|l]_.m"</code>, where
            <ul><li> <code>a</code> for the affine transformation of the argument, <code>say y = sqrt(w(2)* x + w(1));</code>
            </li><li> <code>l<code> for the linear transformation, say <code>y = sqrt(w(1)* x);</code>
            </li><li> the sign <code>"_"</code> is used to avoid possible collision with the other Matlab functions
            </li></ul>
    </li></ul>
</li><li>Make the initial model file <code>"filename.mdl.txt"</code> with the content
<pre><code>
foo2_(foo_(foo2_(x1, foo_(x2))),...)
</code></pre>
all function <code>foo_, foo2_<code> must be in the registry file. See more examples in <code>"demo.mdl.txt"</code>. 
</li><li> Make the project file <code>"filename.prj.txt"</code> with the content
<pre><code>
DataFile     = 'filename.dat.txt'; 
ModelsFile   = 'filename.mdl.txt';
RegistryFile = 'filename.reg.txt'; 
...
</code></pre>
etc. see for example <code>"demo.prj.txt"</code>.
</li><li> Place these files in the folder <code>"mvr\data\"</code> and run <code>main('filename.prj.txt')</code>.
</li></ol>
</body></html>
