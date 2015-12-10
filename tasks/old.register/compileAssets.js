module.exports = function (grunt) {
	grunt.registerTask('compileAssets', [
		'clean:dev',
		'jade:dev',
		'copy:dev',
		'jst:dev',
		'coffee:dev',
		'sass:dev'
	]);
};
