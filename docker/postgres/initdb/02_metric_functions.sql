drop function if exists metric.fn_metrics;
create or replace function metric.fn_metrics(p_limit int, p_offset int)
    returns table
            (
                metric_id             int,
                metric_name           varchar(255),
                metric_type_id        smallint,
                type_name             varchar(255),
                translation_id        smallint,
                translation_name      varchar(255),
                formula_id            int,
                formula_name          text,
                formula_code_function varchar(100),
                is_standardized       boolean,
                perturb_direction     perturbation_directions,
                description           text,
                created_date          text,
                updated_date          text
            )
    language sql
as
$$

select m.metric_id,
       m.metric_name,
       m.metric_type_id,
       mt.type_name,
       m.translation_id,
       t.translation_name,
       m.formula_id,
       f.display_text,
       f.code_function,
       m.is_standardized,
       m.perturb_direction,
       m.description,
       to_json(m.created_date)#>> '{}',
       to_json(m.updated_date)#>> '{}'
from metric.metrics m
         inner join
     (
         select mm.*
         from metric.metrics mm
         order by mm.metric_id
         limit p_limit offset p_offset
     ) ml on m.metric_id = ml.metric_id
         inner join metric.metric_types mt on m.metric_type_id = mt.metric_type_id
         inner join taxa.translations t on m.translation_id = t.translation_id
         left join metric.formulae f on m.formula_id = f.formula_id
$$;