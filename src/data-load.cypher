//
// Load the csv into the database as a new object structure
// - we create our parent agency, then for each 
// - keyword in the row, we create a related Research node
// - we then related the two nodes through the AGENCY_RESEARCH relationship
//
//  To load with header, use the following syntax
//  LOAD CSV WITH HEADERS FROM 'file:///aaa.csv' AS row 
//  MERGE (a:AAA {OID: row.OID}) 
//  
// DELETE AGENCY_RESEACH relatoinship, the Research, then Agency to clear the db
//  MATCH p=()-[r:AGENCY_RESEARCH]->() DELETE p
//  MATCH (n:Research) DELETE n
//  MATCH (n:Agency) DELETE n
//
//
LOAD CSV FROM "file:////clean_sbir_data.csv"
AS row
CREATE ( a:Agency {
    OID: row[6],
    company: row[0],
    awardTitle: row[1],
    agency: row[2],
    branch: row[3],
    phase: row[4],
    program: row[5],
    agencyTrackingNumber: row[6],   
    contract: row[7],
    proposalAwardDate: date({ 
        year: toInteger(substring(row[8],6,4)),
        month: toInteger(substring(row[8],0,2)),
        day:toInteger(substring(row[8],3,2))
    }),
    contractEndDate: date({ 
        year: toInteger(substring(row[9],6,4)),
        month: toInteger(substring(row[9],0,2)),
        day:toInteger(substring(row[9],3,2))
    }),
    solicitationNumber: row[10],
    solicitationYear: date({ 
        year: toInteger(substring(row[11],0,4))      
    }),
    topicCode: row[12],
    awardYear: date({ 
        year: toInteger(substring(row[13],0,4))      
    }),
    awardAmount: toFloat(replace(row[14], "$", "")),
    duns: row[15],
    hubzoneOwned: row[16],
    sociallyAndEconomicallyDisadvantaged: row[17],
    womanOwned: row[18],
    numberEmployees: row[19],
    companyWebsite: row[20],
    address1: row[21],
    address2: row[22],
    city: row[23],
    state: row[24],
    zip: row[25],
    contactName: row[26],
    contactTitle: row[27],
    contactPhone: row[28],
    contactEmail: row[29],
    piName: row[30],
    piTitle: row[31],
    piPhone: row[32],
    piEmail: row[33],
    riName: row[34],
    riPocName: row[35],
    riPocPhone: row[36],
    researchKeywords: row[37],
    abstract: row[38]
})
FOREACH(word in split(row[37], ',') | 
     MERGE ( b:Research { OID: word }) MERGE (a)-[:AGENCY_RESEARCH]->(b))