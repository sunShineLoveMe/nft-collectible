#NFt Hardhat Project

本工程是编写Nft智能合约，并允许任何人通过支付gas从藏品中mint NFT

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
备注：
前置条件：
1. 本项目测试网是goerli，节点链接用的是 alchemy.
2. 下载之后，需要安装dotenv, 防止敏感信息的泄露，新建.env文件，将密钥等信息写入供项目使用。
问题Q&A
1. 在合约验证的时候，通过Hardhat进行验证，提示timeout，因此本合约验证是通过
   区块链浏览器进行验证。
2. 在问题1中，在区块链浏览器进行验证的时候，也是提示compiler编译失败，通过将compiler
    版本update到0.8.8以上，重新编译就可以了，之前是0.8.4 这个也需要注意一下（仅针对本项目）
