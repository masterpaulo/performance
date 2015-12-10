// module.exports = function (grunt) {
// 	grunt.registerTask('linkAssetsBuildProd', [
// 		'sails-linker:prodJsRelative',
// 		'sails-linker:prodStylesRelative',
// 		'sails-linker:devTpl',
// 		'sails-linker:prodJsRelativeJade',
// 		'sails-linker:prodStylesRelativeJade',
// 		'sails-linker:devTplJade'
// 	]);
// };
module.exports = function (grunt) {
	var tasks = [];
	var users = require("../pipeline").users;

	for(var user in users){
		var names = {
			prodJs:"prodJs_"+user,
			prodStyles:"prodStyles_"+user,
			devTpl:"devTpl_"+user
		}
		for(var key in names){
			tasks.push("sails-linker:"+names[key]);
		}
	};

	grunt.registerTask('linkAssetsBuildProd',tasks);
};
