SELECT * FROM exercicio1.curtida;

create table exercicio1.aluno ( 
	id int primary key not null,
	des_nome varchar(255),
    num_grau int
);

insert into exercicio1.aluno values (1, 'Maria', 6);
insert into exercicio1.aluno values (2, 'Joao', 7);

create table exercicio1.curtida (
    fk_aluno1 int,
    constraint fk_aluno1 foreign key (fk_aluno1) references exercicio1.aluno(id),
    fk_aluno2 int,
    constraint fk_aluno2 foreign key (fk_aluno2) references exercicio1.aluno(id)
);

create table exercicio1.amigo (
    fk_amigo1 int,
    constraint fk_amigo1 foreign key (fk_amigo1) references exercicio1.aluno(id),
    fk_amigo2 int,
    constraint fk_amigo2 foreign key (fk_amigo2) references exercicio1.aluno(id)
);

insert into exercicio1.curtida values (1, 2);
insert into exercicio1.amigo values (1, 2);
insert into exercicio1.curtida values (2, 1);
insert into exercicio1.amigo values (2, 1);
insert into exercicio1.curtida values (1, 2);
insert into exercicio1.amigo values (1, 2);

select from exercicio1.aluno left join exercicio1.amigo on aluno.id = amigo.fk_amigo1;

select * from exercicio1.aluno INNER JOIN exercicio1.amigo on aluno.id = amigo.fk_amigo1;