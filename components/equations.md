#### 自己相関係数

$$
r_{k}= \frac{\displaystyle\sum_{t=k+1}^{n} \left ( y_{t}-\bar{y} \right )\left ( y_{t-k}-\bar{y}  \right )}{\displaystyle\sum_{t=1}^{n}\left ( y_{t}-\bar{y} \right )^{2}}
$$

- 参考文献
    1. https://upo-net.ouj.ac.jp/tokei/xml/k3_03012.xml
    1. http://www.statpower.net/Content/311/R%20Stuff/SampleMarkdown.html

***

#### ダービー･ワトソン比

$$
\begin{align}
y_{t} &=\alpha +\beta x_{t}+u_{t}\\
u_{t} &=\rho u_{t-1}+\epsilon _{t}\\
DW &=\frac{\displaystyle\sum_{t=2}^{T}\left ( \hat{u_{t}}-\hat{u_{t-1}} \right )^{2}}{\displaystyle\sum_{t=1}^{T}\hat{u_{t}}^{2}}\\
H_{0} &:系列相関なし. \hat{\rho}=0
\end{align}
$$

- 参考文献
    1. http://www2.econ.osaka-u.ac.jp/~tanizaki/class/2004/szemi/0525/dw.pdf
    1. http://www.econ.nagoya-cu.ac.jp/~kamiyama/siryou/regress/EXCELreg.html

***

#### 共和分検定

$$
共に単位根時系列である\{x_{t}\}と\{y_{t}\}が共和分関係にあるとは\\
y_{t}=\alpha+\beta x_{t}+v_{t}\\
における誤差項\{v_{t}\}が定常となること。\\
H_{0}:共和分関係なし
$$

- 参考文献
    1. https://hermes-ir.lib.hit-u.ac.jp/rs/bitstream/10086/17664/1/0100904001.pdf
    1. http://www2.kumagaku.ac.jp/teacher/~sasayama/macroecon/mailmagacointeg.html
    1. http://user.keio.ac.jp/~nagakura/R/R_cointegration.pdf
    1. http://jasp.ism.ac.jp/~shazam/man8.0/Chap13.pdf
