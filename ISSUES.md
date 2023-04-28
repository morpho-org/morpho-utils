# Known Issues

Libraries released within this repository have some known issues that can't be fixed because of the way they are defined. Here is listed all the known issues the dev team could identify.

## [CompoundMath](./src/math/CompoundMath.sol)

Given the following operations:

```solidity
function mul(uint256 x, uint256 y) internal pure returns (uint256) {
    return (x * y) / 1e18;
}

function div(uint256 x, uint256 y) internal pure returns (uint256) {
    return ((1e18 * x * 1e18) / y) / 1e18;
}
```

The following theorem does not hold:
$\forall x,y, \forall \mu,\nu, (x.mul(\mu) + y.mul(\nu)).div(\mu + \nu) = x.mul(\mu.div(\mu + \nu)) + y.mul(\nu.div(\mu + \nu))$

for values:
$x < 10^{18}, \mu < 10^{18 - \log10(x)}$ and $y < 10^{18}, \nu < 10^{18 - \log10(y)}$

### Example

$x = 10, y = 10, \mu = 10^{16}, \nu = 10^{16}$

$(x.mul(\mu) + y.mul(\nu)).div(\mu + \nu) = 0 + 0 = 0$

$x.mul(\mu.div(\mu + \nu)) + y.mul(\nu.div(\mu + \nu)) = 10.mul(0.5e18) + 10.mul(0.5e18) = 5 + 5 = 10$

### Proof

Because $x \times \mu < 10^{18}$ and $y \times \nu < 10^{18}$ which leads the operation `mul` to truncate to 0

This issue leads rounding errors with values:
$x < 10^{18}, \mu < 10^{18}, \log10(x \times \mu) \geqslant 18$ or $y < 10^{18}, \nu < 10^{18}, \log10(y \times \nu) \geqslant 18$
**[needs a proof]**

But the theorem (at least) holds for values:
$\mu \geqslant 10^{18}$ and $y \geqslant 10^{18}$

---
