pro spline_toolibin_aa
; spline interpolates one spectral sensor to another

; sli input file name
; Check the units of the spectral libaray!!! calculation need to be made if the are not in nanometers!!!
; 
; Directory where spectral library resides, needs trailing backslash or slash
directory = 'F:\spline\AVIRISNG\'
; Define title of spectral library.  Make sure it is consistent with the actual file (i.e., does the file end in .sli ?)
ititle='sensitivity_analysis_4.sli'
; Define wavelength 
newwvl='AVIRISng_2014_MODTRAN_wvl_tp.txt'
; Define the number of new bands
band_num = 432
; Define output file
output=directory+'sensitivity_analysis_4_AVIRISng.sli'
; Define the number of spectra 
spcnum = 30

cd, directory
ifile=directory+ititle


envi_open_file, ifile, r_fid=ifile_fid
envi_file_query, ifile_fid, dims=dims, ns=ns, nl=nl, wl=wvl, spec_names=spec, data_type=dt, interleave=itl, nb=nb,offset=offset, file_type=ft

print,dims, ns,nl,dt,itl,offset, ft

print,wvl(10)

print,spec(10)
ispec=fltarr(ns,nl)
ispec=envi_get_data(fid=ifile_fid, dims=dims, pos=[0])

print,ispec(10,5:15)

owvl_file=newwvl
openr,lun,owvl_file,/GET_LUN
nos=band_num
owvl=fltarr(nos)
readf,lun,owvl
print,owvl(10)


ospec=fltarr(nos,nl)

for i=0,spcnum-1 do begin   
   ospec(*,i)=spline(wvl(*),ispec(*,i),(owvl(*)))  
endfor


print,ispec(0:10,0), ospec(0:10,0)

free_lun,lun

ofile=output
openw,unit,ofile,/get_lun
writeu,unit,ospec
free_lun, unit

ENVI_SETUP_HEAD, fname=ofile,ns=nos, nl=nl, wl=owvl, spec_names=spec, data_type=dt, interleave=itl, nb=nb,offset=offset, file_type=ft, /write,/open

print,'done!'

end