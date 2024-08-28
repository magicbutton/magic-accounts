/* 
File have been automatically created. To prevent the file from getting overwritten
set the Front Matter property ´keep´ to ´true´ syntax for the code snippet
---
keep: false
---
*/   


-- sherry sild

CREATE OR REPLACE FUNCTION proc.update_company(
    p_actor_name VARCHAR,
    p_params JSONB
   
)
RETURNS JSONB LANGUAGE plpgsql 
AS $$
DECLARE
    v_id INTEGER;
       v_rows_updated INTEGER;
v_tenant VARCHAR COLLATE pg_catalog."default" ;
    v_searchindex VARCHAR COLLATE pg_catalog."default" ;
    v_name VARCHAR COLLATE pg_catalog."default" ;
    v_description VARCHAR COLLATE pg_catalog."default";
    v_vatnumber VARCHAR;
    v_phonenumber VARCHAR;
    v_address VARCHAR;
    v_city VARCHAR;
    v_postalcode VARCHAR;
    v_country_id INTEGER;
        v_audit_id integer;  -- Variable to hold the OUT parameter value
    p_auditlog_params jsonb;

    
BEGIN
    v_id := p_params->>'id';
    v_tenant := p_params->>'tenant';
    v_searchindex := p_params->>'searchindex';
    v_name := p_params->>'name';
    v_description := p_params->>'description';
    v_vatnumber := p_params->>'vatnumber';
    v_phonenumber := p_params->>'phonenumber';
    v_address := p_params->>'address';
    v_city := p_params->>'city';
    v_postalcode := p_params->>'postalcode';
    v_country_id := p_params->>'country_id';
         
    
        
    UPDATE public.company
    SET updated_by = p_actor_name,
        updated_at = CURRENT_TIMESTAMP,
        tenant = v_tenant,
        searchindex = v_searchindex,
        name = v_name,
        description = v_description,
        vatnumber = v_vatnumber,
        phonenumber = v_phonenumber,
        address = v_address,
        city = v_city,
        postalcode = v_postalcode,
        country_id = v_country_id
    WHERE id = v_id;

    GET DIAGNOSTICS v_rows_updated = ROW_COUNT;
    
    IF v_rows_updated < 1 THEN
        RAISE EXCEPTION 'No records updated. company ID % not found', v_id ;
    END IF;


           p_auditlog_params := jsonb_build_object(
        'tenant', '',
        'searchindex', '',
        'name', 'update_company',
        'status', 'success',
        'description', '',
        'action', 'update_company',
        'entity', 'company',
        'entityid', -1,
        'actor', p_actor_name,
        'metadata', p_params
    );
/*###MAGICAPP-START##
{
   "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://booking.services.koksmat.com/.schema.json",
   
  "type": "object",

  "properties": {
    "title": "Update Company",
  "description": "Update operation",
  
    "tenant": { 
    "type": "string",
    "description":"" },
    "searchindex": { 
    "type": "string",
    "description":"Search Index is used for concatenating all searchable fields in a single field making in easier to search\n" },
    "name": { 
    "type": "string",
    "description":"" },
    "description": { 
    "type": "string",
    "description":"" },
    "vatnumber": { 
    "type": "string",
    "description":"" },
    "phonenumber": { 
    "type": "string",
    "description":"" },
    "address": { 
    "type": "string",
    "description":"" },
    "city": { 
    "type": "string",
    "description":"" },
    "postalcode": { 
    "type": "string",
    "description":"" },
    "country_id": { 
    "type": "number",
    "description":"" }

    }
}
##MAGICAPP-END##*/

    return jsonb_build_object(
    'comment','updated',
    'id',v_id
    );
END;
$$ 
;


