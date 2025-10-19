
import SwiftUI

struct CopyTableDemo: View {
    @State private var pokemons = Pokemon.pokemonList
    
    @State private var error: Bool = false
    var body: some View {
        
        VStack(spacing: 24) {
            VStack(alignment: .leading) {
                HStack(spacing: 24, content: {
                    Text("Copy-able Table")
                        .font(.title3)
                        .fontWeight(.bold)
                    

                    Button(action: {
                        error = false
                        let pasteboard = NSPasteboard.general
                        // Before we write, we HAVE TO call either declareTypes(_:owner:), or clearContents()
                        // Otherwise write will fail, ie: `result` will be `false`.
                        pasteboard.clearContents()
                        let tableTSV = getTableTSV()
                        // for type, use string instead of tabular data!
                        let result = pasteboard.setString(tableTSV, forType: .string)
                        error = !result
                        print(result)
                    }, label: {
                        Text("Copy")
                    })
                })
                
                if error {
                    Text("Error copying table")
                        .foregroundStyle(.red)
                }
            }

            
            Table(pokemons) {
                TableColumn(Pokemon.indexHeader, value: \.index)
                    .width(56)
                TableColumn(Pokemon.nameHeader, value: \.name)
                    .width(120)
                TableColumn(Pokemon.typeHeader, value: \.typesDisplayString)
                    .width(120)
            }
            .frame(width: 320, height: 140)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    // Create a TSV string for table data compatible with pasting into Notes & Numbers.
    func getTableTSV() -> String {
        // Map each row into a tab-delimited line.
        var tableRowData = pokemons.map(\.dataRow)
        tableRowData.insert(Pokemon.headerRow, at: 0)
        // Create a multiline string with one row per line.
        return tableRowData.joined(separator: "\n")
    }
}


struct Pokemon: Identifiable {
    var id: Int
    var name: String
    var types: [PokemonType]
    
    var typesDisplayString: String {
        self.types.map({ $0.rawValue}).joined(separator: ", ")
    }
    
    var index: String {
        return "No.\(self.id)"
    }
    
    var dataRow: String {
        let values = [self.index, self.name, self.typesDisplayString]
        return values.joined(separator: "\t")
    }
}

extension Pokemon {
    static let indexHeader: String = "Index"
    static let nameHeader: String = "Name"
    static let typeHeader: String = "Type"

    static var headerRow: String {
        let headerKeys = [indexHeader, nameHeader, typeHeader]
        return headerKeys.joined(separator: "\t")
    }
}


enum PokemonType: String {
    case poison
    case fire
    case water
    case grass
    case electric
}

extension Pokemon {
    static let pokemonList = [bulbasaur, charmander, squirtle, pikachu]
    static let bulbasaur = Pokemon(id: 1, name: "bulbasaur", types: [.grass, .poison])
    static let charmander = Pokemon(id: 4, name: "charmander", types: [.fire])
    static let squirtle = Pokemon(id: 7, name: "squirtle", types: [.water])
    static let pikachu = Pokemon(id: 25, name: "pikachu", types: [.electric])
}


#Preview {
    CopyTableDemo()
}
