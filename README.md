function generateDartClass(json: any, className: string = "Root"): string {
    let result = `class ${className} {\n`;
    let nestedClasses = "";
    
    // Generate class fields
    for (const key in json) {
        if (json.hasOwnProperty(key)) {
            const value = json[key];
            const dartType = getDartType(key, value);

            if (typeof value === "object" && !Array.isArray(value)) {
                const nestedClassName = capitalizeFirstLetter(key);
                nestedClasses += generateDartClass(value, nestedClassName) + "\n";
                result += `  final ${nestedClassName} ${key};\n`;
            } else if (Array.isArray(value) && value.length > 0 && typeof value[0] === "object") {
                const nestedClassName = capitalizeFirstLetter(key) + "Item";
                nestedClasses += generateDartClass(value[0], nestedClassName) + "\n";
                result += `  final List<${nestedClassName}> ${key};\n`;
            } else {
                result += `  final ${dartType} ${key};\n`;
            }
        }
    }

    // Constructor
    result += "\n  " + className + "({\n";
    for (const key in json) {
        if (json.hasOwnProperty(key)) {
            result += `    required this.${key},\n`;
        }
    }
    result += "  });\n\n";

    // fromJson method
    result += `  factory ${className}.fromJson(Map<String, dynamic> json) {\n`;
    result += `    return ${className}(\n`;
    for (const key in json) {
        if (json.hasOwnProperty(key)) {
            const value = json[key];
            const dartType = getDartType(key, value);

            if (typeof value === "object" && !Array.isArray(value)) {
                const nestedClassName = capitalizeFirstLetter(key);
                result += `      ${key}: ${nestedClassName}.fromJson(json['${key}']),\n`;
            } else if (Array.isArray(value) && value.length > 0 && typeof value[0] === "object") {
                const nestedClassName = capitalizeFirstLetter(key) + "Item";
                result += `      ${key}: (json['${key}'] as List).map((item) => ${nestedClassName}.fromJson(item)).toList(),\n`;
            } else {
                result += `      ${key}: json['${key}'],\n`;
            }
        }
    }
    result += `    );\n  }\n\n`;

    // toJson method
    result += `  Map<String, dynamic> toJson() {\n`;
    result += `    return {\n`;
    for (const key in json) {
        if (json.hasOwnProperty(key)) {
            const value = json[key];

            if (typeof value === "object" && !Array.isArray(value)) {
                result += `      '${key}': ${key}.toJson(),\n`;
            } else if (Array.isArray(value) && value.length > 0 && typeof value[0] === "object") {
                result += `      '${key}': ${key}.map((item) => item.toJson()).toList(),\n`;
            } else {
                result += `      '${key}': ${key},\n`;
            }
        }
    }
    result += `    };\n  }\n}\n\n`;

    return result + nestedClasses;
}

function getDartType(key: string, value: any): string {
    if (typeof value === "number") return value % 1 === 0 ? "int" : "double";
    if (typeof value === "boolean") return "bool";
    if (typeof value === "string") return "String";
    if (Array.isArray(value)) return value.length > 0 ? `List<${getDartType(key, value[0])}>` : "List<dynamic>";
    if (typeof value === "object") return capitalizeFirstLetter(key);
    return "dynamic";
}

function capitalizeFirstLetter(text: string): string {
    return text.charAt(0).toUpperCase() + text.slice(1);
}
