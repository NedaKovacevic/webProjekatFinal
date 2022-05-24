create database Biletarnica2
use Biletarnica2

create table sediste
(
	id int identity(1,1) primary key,
	red int,
	broj int,
	kolicina int,
	slobodno int,
	cena int
)

create table Korisnik(
	id int primary key identity(1,1),
	email varchar(50),
	lozinka varchar(50)
)

create table koncert(
	id int primary key identity(1,1),
	lokacija varchar(30),
	izvodjac varchar(50)
)
create table vreme
(
	id int primary key identity(1,1),
	dan date,
	vreme time
)

create table rezervacija
(
	id int identity(1,1) primary key,
	korisnikID int foreign key references korisnik(id),
	koncertID int foreign key references koncert(id),
	sedisteID int foreign key references sediste(id),
	vremeID int foreign key references vreme(id)
)

go
create proc KorisnikLogin
@email varchar(50),
@lozinka varchar(20)
as
begin try
if exists (select top 1 email,lozinka from Korisnik where email = @email and lozinka= @lozinka)
	Begin
		Return 1
	End
	Return 0
end try
Begin Catch
	Return @@error
End Catch
go
create proc UnosKorisnika
@email varchar(50),
@sifra varchar(20)
as
begin try
if exists (select top 1 email,lozinka from Korisnik where email = @email and lozinka= @sifra)
	return 1
	else
	insert into Korisnik (email,lozinka) 
	Values (@email,@sifra)
		Return 0;
end try
Begin Catch
	return @@error
End Catch
go
create proc KoncertiPrikaz
@izvodjac varchar(50)
as
begin try
select top 1 id from Koncert where @izvodjac=izvodjac
end try
Begin Catch
	Return @@error
End catch
go

go
create proc SearchSediste
@br varchar(30),
@red varchar(50)
as
begin try
select * from sediste where ((red like @red) and (broj like @br) and(slobodno like 0))
end try 
Begin Catch
	Return @@error
end Catch

go
create proc MojeKarte
@email varchar(50)
as
begin try
select * from Rezervacija join Korisnik on korisnikID=Korisnik.id join Koncert on koncertID=koncert.id join Sediste on sedisteID=sediste.id where @email= Korisnik.email
end try
Begin Catch
	Return @@error
end Catch
go

go
create proc ZakaziKarte
@korisnik int,
@koncert int,
@vreme varchar(10),
@sediste varchar(20)
as
begin try 
if exists (select top 1 * from rezervacija where korisnikID=@korisnik and @koncert=koncertID and @vreme=vremeID and sedisteID=@sediste)
		Begin
			Return 0
		End
	Insert Into rezervacija(korisnikID,koncertID,vremeID,sedisteID) Values (@korisnik,@koncert,@vreme,@sediste)
	Return 1
end try
Begin Catch
	Return @@error
End catch
go