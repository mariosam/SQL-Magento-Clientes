SELECT
	c.`entity_id` AS ID,
	/* juntando nome + sobrenome na mesma saida */
	CONCAT( addr_firstname.`value`, " ", addr_lastname.`value` ) AS NomeCompleto,
	-- addr_firstname.`value` AS Nome,
	-- addr_lastname.`value` AS Sobrenome,
    c.`email` AS Email,
    customer_group.`customer_group_code` AS Grupo,
    /* caso queira formatar a saida da data */
	-- DATE_FORMAT(c.`created_at`, '%d/%m/%Y') AS ClienteDesde
    c.`created_at` AS ClienteDesde,
	addr_telephone.`value` AS Telefone,
    addr_zipcode.`value` AS Cep,
    addr_street.`value` AS Endereco,
    addr_city.`value` AS Cidade,
    addr_region.`value` AS Estado,
    addr_country.`value` AS Pais

FROM
    customer_entity AS c
        INNER JOIN customer_address_entity AS a ON a.`parent_id` = c.`entity_id`

-- codes from Magento 1.9.3.9
-- city=26, country_id=27, firstname=20, lastname=22, postcode=30, street=25, telephone=31, region=28,region_id=29
LEFT JOIN customer_address_entity_varchar AS addr_zipcode ON
    a.`entity_id` = addr_zipcode.`entity_id` AND addr_zipcode.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'postcode' AND eav.entity_type_id = 2)
LEFT JOIN customer_address_entity_varchar AS addr_city ON
    a.`entity_id` = addr_city.`entity_id` AND addr_city.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'city' AND eav.entity_type_id = 2)
LEFT JOIN customer_address_entity_varchar AS addr_country ON
    a.`entity_id` = addr_country.`entity_id` AND addr_country.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'country_id' AND eav.entity_type_id = 2)
LEFT JOIN customer_address_entity_varchar AS addr_firstname ON
    a.`entity_id` = addr_firstname.`entity_id` AND addr_firstname.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'firstname' AND eav.entity_type_id = 2)
LEFT JOIN customer_address_entity_varchar AS addr_lastname ON
    a.`entity_id` = addr_lastname.`entity_id` AND addr_lastname.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'lastname' AND eav.entity_type_id = 2)
LEFT JOIN customer_address_entity_text AS addr_street ON
    a.`entity_id` = addr_street.`entity_id` AND addr_street.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'street' AND eav.entity_type_id = 2)
LEFT JOIN customer_address_entity_varchar AS addr_telephone ON
    a.`entity_id` = addr_telephone.`entity_id` AND addr_telephone.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'telephone' AND eav.entity_type_id = 2)
LEFT JOIN customer_address_entity_varchar AS addr_region ON
    a.`entity_id` = addr_region.`entity_id` AND addr_region.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'region' AND eav.entity_type_id = 2)
LEFT JOIN customer_address_entity_int AS addr_region_id ON
    a.`entity_id` = addr_region_id.`entity_id` AND addr_region_id.`attribute_id` = 
    	(SELECT attribute_id FROM eav_attribute AS eav WHERE eav.attribute_code = 'region_id' AND eav.entity_type_id = 2)
LEFT JOIN directory_country_region AS addr_region_code ON
    addr_region_id.`value` = addr_region_code.`region_id`
    
-- tabela apenas para pegar o nome do gurpo
LEFT JOIN customer_group AS customer_group ON 
	customer_group.`customer_group_id` = c.`group_id`
    
