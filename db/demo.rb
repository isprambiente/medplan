# frozen_string_literal: true

admin = User.new(username: 'admin', label: 'Admin', name: 'Admin', password: 'admin', password_confirmation: 'admin', cf: '-', city: :roma, admin: true, system: true)
admin.save(validate: false)
dottore = User.new(username: 'dottore', label: 'Dottore', name: 'Dottore', password: 'dottore', password_confirmation: 'dottore', city: :roma, doctor: true, cf: 'DOTTORE1', system: true)
dottore.save(validate: false)
segretaria = User.new(username: 'segretaria', label: 'Segretaria', name: 'Segretaria', password: 'segretaria', password_confirmation: 'segretaria', city: :roma, secretary: true, cf: 'SEGRETARIA1', system: true)
segretaria.save(validate: false)
mario = User.new(username: 'mario.rossi', label: 'Rossi Mario', name: 'Mario', lastname: 'Rossi', password: 'mario', password_confirmation: 'mario', city: :roma, cf: 'RSSMRA69A01H501Z', system: true)
mario.save(validate: false)
utente = User.new(username: 'giorgio.verdi', label: 'Verdi Giorgio', name: 'Giorgio', lastname: 'Verdi', password: 'giorgio', password_confirmation: 'giorgio', city: :venezia, cf: 'VRDGRG80A01L736Q')
utente.save(validate: false)
utente = User.new(username: 'grazia.bianchi', label: 'Bianchi Grazia', name: 'Grazia', lastname: 'Bianchi', password: 'grazia', password_confirmation: 'grazia', cf: 'BNCGRZ63A41F205Z', city: :livorno)
utente.save(validate: false)
