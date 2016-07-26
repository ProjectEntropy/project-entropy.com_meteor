# test timeout
timeout = 20000

web3 = new Web3()

{ FlowRouter } = require 'meteor/kadira:flow-router'
chai = require 'chai'

describe 'web3 connectivity', ->
  it 'should connect to web3', (done) ->
    web3.setProvider new (web3.providers.HttpProvider)('http://localhost:8545')
    done()
    return

  it 'should provide valid gas price', (done) ->
    web3.eth.getGasPrice (err, result) ->
      chai.assert.isNull err, null
      chai.assert.property result, 'toNumber'
      chai.assert.isNumber result.toNumber(10)
      done()
      return
    return
  return
# Construct Multiply Contract Object and contract instance
contractInstance = undefined
transactionObject =
  data: Organization.bytecode
  gasPrice: web3.eth.gasPrice
  gas: 500000
  from: web3.eth.accounts[0]
describe 'Organization unit tests', ->
  it 'should deploy a new Organization', (done) ->
    @timeout timeout
    Organization.new transactionObject, (err, contract) ->
      chai.assert.isNull err
      if contract.address
        contractInstance = contract
        done()
      return
    return
  #
  # it("should multiply 0 * 7 to equal 0", function(done){
  #     this.timeout(timeout);
  #
  #     contractInstance.multiply.call(0, function(err, result){
  #         chai.assert.isNull(err);
  #         chai.assert.equal(result.toNumber(10), 0);
  #         done();
  #     });
  # });
  #
  # it("should multiply 7 * 7 to equal 49", function(done){
  #     this.timeout(timeout);
  #
  #     contractInstance.multiply.call(7, function(err, result){
  #         chai.assert.isNull(err);
  #         chai.assert.equal(result.toNumber(10), (7 * 7));
  #         done();
  #     });
  # });
  #
  # it("should multiply 4 * 7 to equal 28", function(done){
  #     this.timeout(timeout);
  #
  #     contractInstance.multiply.call(4, function(err, result){
  #         chai.assert.isNull(err);
  #         chai.assert.equal(result.toNumber(10), (4 * 7));
  #         done();
  #     });
  # });
  return
#
#
# describe("MultiplyContract unit tests", function(){
#     it("should deploy a new MultiplyContract", function(done){
#         this.timeout(timeout);
#
#         MultiplyContract.new(transactionObject,
#                              function(err, contract){
#             chai.assert.isNull(err);
#
#             if(contract.address) {
#                 contractInstance = contract;
#                 done();
#             }
#         });
#     });
#
#     it("should multiply 0 * 7 to equal 0", function(done){
#         this.timeout(timeout);
#
#         contractInstance.multiply.call(0, function(err, result){
#             chai.assert.isNull(err);
#             chai.assert.equal(result.toNumber(10), 0);
#             done();
#         });
#     });
#
#     it("should multiply 7 * 7 to equal 49", function(done){
#         this.timeout(timeout);
#
#         contractInstance.multiply.call(7, function(err, result){
#             chai.assert.isNull(err);
#             chai.assert.equal(result.toNumber(10), (7 * 7));
#             done();
#         });
#     });
#
#     it("should multiply 4 * 7 to equal 28", function(done){
#         this.timeout(timeout);
#
#         contractInstance.multiply.call(4, function(err, result){
#             chai.assert.isNull(err);
#             chai.assert.equal(result.toNumber(10), (4 * 7));
#             done();
#         });
#     });
# });
