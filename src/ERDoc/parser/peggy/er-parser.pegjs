{{
  const KEYWORDS = [
"entity",
"extends",
"key",
"pkey",
"relation",
"aggregation",
"depends on"
  ]

  function getLocation(location_fun) {
    const location = location_fun();
    const { source, ...rest } = location;
    return rest;
  }
}}


start
  = all:((entity/weakEntity/relationship/aggregation)/_{return null})* {
    const elements = all.filter(ele => ele != null)
    const er = {entities: [], relationships: [], aggregations: []};
    for (const e of elements) {
    	if (e.type == "entity") er.entities.push(e);
        if (e.type == "relationship") er.relationships.push(e);
        if (e.type == "aggregation") er.aggregations.push(e);
    }
  	return er;
  }

// BEGIN WEAK ENTITY
weakEntity = 
	declaration:(declareEntity _ identifier:entityIdentifier { return { identifier, location: getLocation(location)}})
    dependsOn:(_ deps:declareWeak{return deps}) _0
    Lcurly _0
        attributes:(
             head:(_0 e:WeakEntityAttribute {return e})
		     tail:( newline _0 e:WeakEntityAttribute  {return e})*
             {return [head, ...tail]}
       	)|0..1|
	    _0
	Rcurly {
        return {
            type: "entity",
            name: declaration.identifier,
            attributes: attributes.length == 0? [] : attributes[0],
            hasParent: false,
            parentName: null,
            hasDependencies: true,
            dependsOn,
            location: declaration.location
        }
    } 
    
    
// Weak entity attributes
WeakEntityAttribute =
	identifier:attributeIdentifier [ \t]* childAttributes:declareComposite? [ \t]* isKey:(declareIsPartialKey {return true})?
    {
    	const attribute = {name: identifier, location: getLocation(location)}
        attribute.isKey = isKey === true
        const isComposite = childAttributes !== null
        attribute.isComposite  = isComposite 
        attribute.childAttributesNames = isComposite ? childAttributes : null
        return attribute
    }
    
listOfDeps = deps:(head:(d:validWord {return d})
				   tail:((","[ \t]*) d:validWord {return d})*
                   {return [head, ...tail]}
                   )
  
declareWeak = dependsOn [ \t]+ relationshipName:listOfDeps
{ return {relationshipName}}
// END WEAK ENTITY

//BEGIN ENTITY
entity = 
	declaration:(declareEntity _ identifier:entityIdentifier {
        return { identifier, location: getLocation(location) }
    }) parentIdentifier:(_ parent:entityExtends{return parent})? _0
    Lcurly _0
        attributes:(
             head:(_0 e:entityAttribute {return e})
		     tail:( newline _0 e:entityAttribute {return e})*
             {return [head, ...tail]}
       	)|0..1|
	    _0
	Rcurly {
        return {
            type: "entity",
            name: declaration.identifier,
            attributes: attributes.length == 0? [] : attributes[0],
            hasParent: parentIdentifier !== null,
            parentName: parentIdentifier,
            hasDependencies: false,
            dependsOn: null,
            location: declaration.location 
        }
    } 
    
// Atributos de la entidad
entityAttribute =
	identifier:attributeIdentifier [ \t]* 
    childAttributes:declareComposite? [ \t]* 
    isKey:(declareIsKey {return true})? [ \t]*
    isMultivalued:(declareIsMultiValued { return true })? [ \t]*
    {
    	const attribute = {name: identifier, location: getLocation(location)}
        attribute.isKey = isKey === true
        attribute.isMultivalued = isMultivalued === true
        const isComposite = childAttributes !== null
        attribute.isComposite = isComposite
        attribute.childAttributesNames = isComposite? childAttributes : null
        return attribute
    }
    

declareComposite =
    beginComposite
        childAttribs: listOfAttributes
    {return childAttribs}

beginComposite = ':' [ \t]*
listOfAttributes =
    Lbracket
        attributes:(
            head:([ \t]* h:attributeIdentifier {return h})
    	    tail:( ',' [ \t]* t:attributeIdentifier {return t})*
            {return [head, ...tail]}
        ) Rbracket
    {return attributes}

// Jerarquia de clase
entityExtends
	= (declareExtends _ parent:parentIdentifier {return parent})   

// END ENTITY


// RELATIONSHIP 
relationship
	= declaration:(declareRelationship _0 identifier:relationshipIdentifier { return { identifier, location: getLocation(location)}}) _0 participants:listOfParticipants attributes:(_0 Lcurly _0
        attribList:(
             head:(_0 e:relationShipAttribute{return e})
		     tail:( newline _0 e:relationShipAttribute{return e})*
             {return [head, ...tail]}
       	)?
    _0
    Rcurly {return attribList === null? [] : attribList})?
    
    {
        return {
    		 type: "relationship",
    		 name: declaration.identifier,
             participantEntities: participants,
    		 attributes: attributes === null? [] : attributes,
             location: declaration.location
             }
    }

relationShipAttribute "relationship attribute " = iden:validWord
 { return{
        name: iden,
        isComposite: false,
        childAttributesNames: null,
        location: getLocation(location)
    }
}

listOfParticipants =
    Lparen
    participants:(
        pHead:([ \t]* p:(CompositeParticipantEntity/participantEntity)  {return p})
        pTail:(','[ \t]* p:(CompositeParticipantEntity/participantEntity) {return p})*
    {return [pHead, ...pTail]}
    ) Rparen
    {return participants}


// begin composite participant in relationship
CompositeParticipantEntity = entityName:entityIdentifier childParticipants:declareCompositeParticipantEntity
{
    return {
        entityName,
        isComposite: true,
        childParticipants,
        location: getLocation(location)
    }
}

declareCompositeParticipantEntity =
    beginComposite
    childParticipants: listOfChildParticipants
    {return childParticipants}

listOfChildParticipants =
    Lbracket
    participants:(
        pHead:([ \t]* p:participantEntity {return p})
        pTail:(','[ \t]* p:participantEntity {return p})*
    {return [pHead, ...pTail]}
    ) Rbracket
    {return participants}
// end composite participant in relationship

// begin participant entity in relationship
participantEntity = entityName:entityIdentifier constraints:declareConstraints? [ \t\n]*{
     {
         let cardinality = "N";
         let isTotal = false;
         if (constraints !== null) {
                cardinality = constraints.cardinality;
                isTotal = constraints.isTotalParticipation;
         }
         return {
                entityName,
                isComposite: false,
                cardinality,
                participation: isTotal? "total" : "partial",
                location: getLocation(location)
         }
    }
}

declareConstraints =
    [ \t]+ c:cardinality isTotal: declareTotalparticipation? 
    {return { cardinality: c, isTotalParticipation: isTotal !== null }}

cardinality = cardinality:(nums:[0-9]+{return nums.join('')} / [A-Z]) { return cardinality }
// end participant entity in relationship
declareTotalparticipation = isTotal:"!" { return true}

// Aggregation
aggregation = declareAggregation _ identifier:aggregationIdentifier _0 Lparen aggregatedRelationshipName:relationshipIdentifier Rparen
 (_0 Lcurly _0 Rcurly)?
{ return {
    type: "aggregation",
    name: identifier,
    aggregatedRelationshipName,
    location: getLocation(location)
    }
}

aggregationIdentifier "aggregation identifier" = validWord
// TOKENS
validWord = characters:([a-zA-Z0-9_áéíóúÁÉÍÓÚñÑ]+) ! {return KEYWORDS.some(kw => kw == characters.join('').toLowerCase())} {return characters.join('')}
Lcurly = "{"
Rcurly = "}"
Lbracket = "["
Rbracket = "]"
Lparen = "("
Rparen = ")"

declareEntity = "entity"i
declareExtends = "extends"i
declareIsKey "key" = "key"
declareIsMultiValued "@" = "@"
declareIsPartialKey "partial key" = "pkey"
declareRelationship = "relation"i
declareAggregation = "aggregation"i
dependsOn = "depends on"i

newline = ("\n"/"\r\n")

whitespace = [ \t\n]/"\r\n"
_ "1 or more whitespaces"  = whitespace+
_0 "0 or more whitespaces" = whitespace*


through = "through"i
WeakEntityDependency "weak relationship identifier" = validWord
entityIdentifier "entity identifier" = validWord
attributeIdentifier "attribute identifier" = validWord
parentIdentifier "parent identifier" = validWord
relationshipIdentifier "relationship identifier" = validWord

